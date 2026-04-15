#!/bin/bash

# TOON Utilities - Management commands for TOON context system
# Provides: verify, stats, cleanup, export, import

set -e

TOON_CONTEXT_DIR="$HOME/.claude/toon-context"
CONVERTER="$HOME/.claude/toon-setup/converter.js"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# ============================================================================
# VERIFY - Check if all tools are properly configured
# ============================================================================
verify() {
  echo -e "${BLUE}Verifying TOON setup...${NC}\n"

  local status=0

  # Check installations
  echo "Installation Status:"
  command -v node &> /dev/null && echo -e "  ${GREEN}✓${NC} Node.js" || { echo -e "  ${RED}✗${NC} Node.js"; status=1; }
  command -v python3 &> /dev/null && echo -e "  ${GREEN}✓${NC} Python 3" || echo -e "  ${YELLOW}○${NC} Python 3 (optional)"
  command -v go &> /dev/null && echo -e "  ${GREEN}✓${NC} Go" || echo -e "  ${YELLOW}○${NC} Go (optional)"
  command -v cargo &> /dev/null && echo -e "  ${GREEN}✓${NC} Rust" || echo -e "  ${YELLOW}○${NC} Rust (optional)"

  # Check tool installations
  echo -e "\nAI Tool Status:"
  command -v claude &> /dev/null && echo -e "  ${GREEN}✓${NC} Claude CLI" || echo -e "  ${RED}✗${NC} Claude CLI"
  command -v gemini &> /dev/null && echo -e "  ${GREEN}✓${NC} Gemini CLI" || { echo -e "  ${YELLOW}○${NC} Gemini CLI"; status=1; }
  command -v agy &> /dev/null && echo -e "  ${GREEN}✓${NC} agy (Antigravity)" || { echo -e "  ${YELLOW}○${NC} agy"; status=1; }
  command -v ollama &> /dev/null && echo -e "  ${GREEN}✓${NC} Ollama" || { echo -e "  ${YELLOW}○${NC} Ollama"; status=1; }

  # Check configurations
  echo -e "\nConfiguration Status:"
  [ -f "$HOME/.claude/settings.json" ] && \
    grep -q "toon" "$HOME/.claude/settings.json" && \
    echo -e "  ${GREEN}✓${NC} Claude settings.json" || \
    echo -e "  ${YELLOW}○${NC} Claude settings.json (TOON not configured)"

  [ -d "$HOME/.config/gemini-cli" ] && \
    [ -f "$HOME/.config/gemini-cli/toon-config.json" ] && \
    echo -e "  ${GREEN}✓${NC} Gemini config" || \
    echo -e "  ${YELLOW}○${NC} Gemini config"

  [ -f "$HOME/.antigravity/toon.toml" ] && \
    echo -e "  ${GREEN}✓${NC} agy config" || \
    echo -e "  ${YELLOW}○${NC} agy config"

  [ -f "$HOME/.ollama/toon-context.json" ] && \
    echo -e "  ${GREEN}✓${NC} Ollama config" || \
    echo -e "  ${YELLOW}○${NC} Ollama config"

  # Check utilities
  echo -e "\nUtility Status:"
  [ -f "$CONVERTER" ] && echo -e "  ${GREEN}✓${NC} TOON converter.js" || { echo -e "  ${RED}✗${NC} TOON converter.js"; status=1; }
  [ -d "$TOON_CONTEXT_DIR" ] && echo -e "  ${GREEN}✓${NC} Context directory" || { echo -e "  ${RED}✗${NC} Context directory"; status=1; }
  [ -f "$HOME/.claude/toon-setup/memory-converter.sh" ] && echo -e "  ${GREEN}✓${NC} Memory converter" || echo -e "  ${YELLOW}○${NC} Memory converter"

  echo ""
  [ $status -eq 0 ] && echo -e "${GREEN}✓ TOON setup complete and verified!${NC}" || echo -e "${YELLOW}⚠ Some components need setup. Run 'toon-setup-config'.${NC}"
  return $status
}

# ============================================================================
# STATS - Show TOON context statistics
# ============================================================================
_fmt_bytes() {
  local b=$1
  if [ "$b" -ge 1048576 ]; then printf "%dM" $((b / 1048576))
  elif [ "$b" -ge 1024 ]; then printf "%dK" $((b / 1024))
  else printf "%dB" "$b"; fi
}

_bar() {
  local pct=$1 width=25
  local filled=$((pct * width / 100))
  local empty=$((width - filled))
  local bar=""
  local i=0
  while [ $i -lt $filled ]; do bar="${bar}█"; i=$((i+1)); done
  while [ $i -lt $width ];  do bar="${bar}░"; i=$((i+1)); done
  printf "%s" "$bar"
}

stats() {
  local savings_log="$TOON_CONTEXT_DIR/savings.log"

  if [ ! -f "$savings_log" ] || [ ! -s "$savings_log" ]; then
    echo "TON Token Savings"
    echo "════════════════════════════════════════════════════════════"
    echo "  No conversions recorded yet. Run 'ton convert' to start."
    return 0
  fi

  # Aggregate totals and per-file rows via awk (bash 3 compatible)
  local summary
  summary=$(awk -F'|' '
    {
      gsub(/ /, "", $2); gsub(/ /, "", $3)
      orig=$2+0; toon=$3+0; fname=$4
      total_orig += orig; total_toon += toon; count++
      # last entry per file wins
      f_orig[fname]=orig; f_toon[fname]=toon
    }
    END {
      saved = total_orig - total_toon
      pct = (total_orig > 0) ? int(saved * 1000 / total_orig) : 0
      printf "TOTALS %d %d %d %d\n", count, total_orig, total_toon, pct
      for (f in f_orig) {
        s = f_orig[f] - f_toon[f]
        fp = (f_orig[f] > 0) ? int(s * 1000 / f_orig[f]) : 0
        printf "FILE %d %d %d %s\n", f_orig[f], f_toon[f], fp, f
      }
    }
  ' "$savings_log")

  local conversions total_original total_toon pct1
  read -r _ conversions total_original total_toon pct1 <<< "$(echo "$summary" | grep ^TOTALS)"

  local saved=$((total_original - total_toon))
  local pct=$((pct1 / 10))
  local pct_fmt="$(echo "$pct1" | awk '{printf "%.1f%%", $1/10}')"

  echo "TON Token Savings"
  echo "════════════════════════════════════════════════════════════"
  printf "Total files:    %s\n"      "$conversions"
  printf "Original size:  %s\n"      "$(_fmt_bytes $total_original)"
  printf "TOON size:      %s\n"      "$(_fmt_bytes $total_toon)"
  printf "Bytes saved:    %s (%s)\n" "$(_fmt_bytes $saved)" "$pct_fmt"
  printf "Efficiency:     %s %s\n"   "$(_bar $pct)" "$pct_fmt"

  echo ""
  echo "By File"
  echo "───────────────────────────────────────────────────────────────────────"
  printf "  %-3s  %-35s  %8s  %8s  %7s  %6s\n" "#" "File" "Original" "TOON" "Saved" "%"
  echo "───────────────────────────────────────────────────────────────────────"

  local rank=1
  echo "$summary" | grep ^FILE | awk '{print $4, $0}' | sort -k1 -rn | while read -r s _ orig toon fp fname; do
    local fp_fmt
    fp_fmt=$(echo "$fp" | awk '{printf "%.1f%%", $1/10}')
    local saved_f=$((orig - toon))
    local short="${fname:0:35}"
    printf " %2s.  %-35s  %8s  %8s  %7s  %6s\n" \
      "$rank" "$short" "$(_fmt_bytes $orig)" "$(_fmt_bytes $toon)" "$(_fmt_bytes $saved_f)" "$fp_fmt"
    rank=$((rank + 1))
  done

  echo "───────────────────────────────────────────────────────────────────────"
}

# ============================================================================
# CLEANUP - Remove old TOON context files
# ============================================================================
cleanup() {
  echo -e "${BLUE}Cleaning up old TOON context files...${NC}\n"

  if [ ! -d "$TOON_CONTEXT_DIR" ]; then
    echo "No context directory to clean."
    return 0
  fi

  local days=${1:-30}
  echo "Removing files older than $days days..."

  find "$TOON_CONTEXT_DIR" -type f -mtime +$days -delete

  echo -e "${GREEN}✓ Cleanup complete${NC}"
  stats
}

# ============================================================================
# EXPORT - Export context to various formats
# ============================================================================
export_context() {
  local format=${1:-json}
  local output=${2:-.}

  echo -e "${BLUE}Exporting TOON context as $format...${NC}"

  if [ ! -d "$TOON_CONTEXT_DIR" ]; then
    echo "No context directory found."
    return 1
  fi

  mkdir -p "$output"

  case "$format" in
    json)
      echo "Converting TOON files to JSON..."
      for toon_file in "$TOON_CONTEXT_DIR"/*.toon; do
        if [ -f "$toon_file" ]; then
          filename=$(basename "$toon_file" .toon)
          node "$CONVERTER" toon-to-json "$toon_file" -o "$output/$filename.json"
        fi
      done
      echo -e "${GREEN}✓ Exported to $output${NC}"
      ;;
    toon)
      cp -r "$TOON_CONTEXT_DIR"/* "$output/" 2>/dev/null || true
      echo -e "${GREEN}✓ TOON files copied to $output${NC}"
      ;;
    md)
      echo "Converting TOON to markdown JSON blocks..."
      for toon_file in "$TOON_CONTEXT_DIR"/*.toon; do
        if [ -f "$toon_file" ]; then
          filename=$(basename "$toon_file" .toon)
          json=$(node "$CONVERTER" toon-to-json "$toon_file")
          echo "# $filename" > "$output/$filename.md"
          echo '```json' >> "$output/$filename.md"
          echo "$json" >> "$output/$filename.md"
          echo '```' >> "$output/$filename.md"
        fi
      done
      echo -e "${GREEN}✓ Markdown files created in $output${NC}"
      ;;
    *)
      echo "Unknown format: $format"
      echo "Supported: json, toon, md"
      return 1
      ;;
  esac
}

# ============================================================================
# INIT - Set up local project memory directory
# ============================================================================
init_project() {
  local project_dir="${1:-$PWD}"
  local toon_dir="$project_dir/.toon"
  local memory_dir="$toon_dir/memory"

  echo -e "${BLUE}Initializing TOON project memory in:${NC} $project_dir\n"

  if [ -d "$memory_dir" ]; then
    echo -e "${YELLOW}Already initialized:${NC} $memory_dir"
    return 0
  fi

  mkdir -p "$memory_dir"

  # Create a sample memory file
  cat > "$memory_dir/project.md" << 'MEMEOF'
---
name: project
description: Project context and goals
type: project
---

# Project Memory

Add project-specific context here. This file is converted to TOON format
automatically when you run `toon-convert` from this directory.

## Goals

## Key Decisions

## Team
MEMEOF

  # Suggest gitignore entry (don't auto-modify)
  if [ -f "$project_dir/.gitignore" ]; then
    if ! grep -q "\.toon/" "$project_dir/.gitignore"; then
      echo -e "${YELLOW}Tip:${NC} Add '.toon/' to .gitignore if you don't want to commit memory files."
      echo "  Run: echo '.toon/' >> $project_dir/.gitignore"
    fi
  fi

  echo -e "${GREEN}✓ Created:${NC} $memory_dir/"
  echo -e "${GREEN}✓ Created:${NC} $memory_dir/project.md"
  echo ""
  echo "Add memory files to $memory_dir/"
  echo "Then run 'toon-convert' to compress them."
}

# ============================================================================
# CONVERT - Convert markdown memory files to TOON
# ============================================================================
convert_memory() {
  echo -e "${BLUE}Converting memory files to TOON format...${NC}\n"

  "$HOME/.claude/toon-setup/memory-converter.sh" convert "$PWD"

  echo -e "\n${GREEN}✓ Memory conversion complete${NC}"
}

# ============================================================================
# MAIN CLI
# ============================================================================
case "${1:-verify}" in
  verify)
    verify
    ;;
  stats)
    stats
    ;;
  cleanup)
    cleanup "${2:-30}"
    ;;
  export)
    export_context "${2:-json}" "${3:-.}"
    ;;
  convert)
    convert_memory
    ;;
  init)
    init_project "${2:-}"
    ;;
  *)
    cat << 'EOF'
TOON Utilities - Manage TOON context storage

Usage: toon-utils <command> [options]

Commands:
  verify                  Verify TOON setup across all tools
  stats                   Show TOON context statistics and savings
  cleanup [days]          Remove context files older than N days (default: 30)
  export <format> [dir]   Export context as json/toon/md (default: json, current dir)
  convert                 Convert markdown memory to TOON format
  init [dir]              Set up local project memory in .toon/memory/ (default: cwd)

Examples:
  toon-utils verify
  toon-utils stats
  toon-utils cleanup 60
  toon-utils export json ./backup
  toon-utils convert
  toon-utils init
  toon-utils init /path/to/project

EOF
    exit 1
    ;;
esac
