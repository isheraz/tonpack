#!/bin/bash

# TOON Global Setup Skill
# Installs and configures TOON format across all AI tools (Claude, Gemini, agy, ollama)
# Converts context storage from markdown to TOON for 60-90% token savings

set -e

TOON_SETUP_DIR="$HOME/.claude/toon-setup"
TOON_CONTEXT_DIR="$HOME/.claude/toon-context"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# ============================================================================
# MAIN SETUP FLOW
# ============================================================================

main() {
  local action="${1:-help}"

  case "$action" in
    install)
      install_all
      ;;
    configure)
      configure_all
      ;;
    verify)
      verify_setup
      ;;
    stats)
      show_stats
      ;;
    reset)
      reset_setup
      ;;
    *)
      show_help
      ;;
  esac
}

# ============================================================================
# STEP 1: Install Dependencies
# ============================================================================

install_all() {
  echo -e "\n${BLUE}╔════════════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║ TOON Global Setup - Installing Dependencies   ║${NC}"
  echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}\n"

  # Ensure setup directory exists
  mkdir -p "$TOON_SETUP_DIR"
  mkdir -p "$TOON_CONTEXT_DIR"

  # 1. Install converter.js if not present
  if [ ! -f "$TOON_SETUP_DIR/converter.js" ]; then
    bash "$TOON_SETUP_DIR/install-dependencies.sh" || {
      echo -e "${RED}✗ Failed to install dependencies${NC}"
      return 1
    }
  else
    echo -e "${GREEN}✓${NC} TOON converter already installed"
  fi

  echo -e "\n${GREEN}✓ Installation complete!${NC}"
}

# ============================================================================
# STEP 2: Configure All Tools
# ============================================================================

configure_all() {
  echo -e "\n${BLUE}╔════════════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║ TOON Global Setup - Configuring AI Tools      ║${NC}"
  echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}\n"

  if [ ! -f "$TOON_SETUP_DIR/configure-ai-tools.sh" ]; then
    echo -e "${RED}✗ Configuration script not found${NC}"
    return 1
  fi

  bash "$TOON_SETUP_DIR/configure-ai-tools.sh" || {
    echo -e "${RED}✗ Failed to configure AI tools${NC}"
    return 1
  }

  echo -e "\n${GREEN}✓ Configuration complete!${NC}"
}

# ============================================================================
# STEP 3: Verify Setup
# ============================================================================

verify_setup() {
  echo -e "\n${BLUE}Verifying TOON setup...${NC}\n"

  bash "$TOON_SETUP_DIR/toon-utils.sh" verify

  if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}✓ Setup verified successfully!${NC}"
    echo -e "\n${BLUE}Run 'ton help' to see all available commands.${NC}"
  fi
}

# ============================================================================
# Show Statistics
# ============================================================================

show_stats() {
  bash "$TOON_SETUP_DIR/toon-utils.sh" stats
}

# ============================================================================
# Reset/Uninstall
# ============================================================================

reset_setup() {
  echo -e "${YELLOW}⚠ This will remove TOON configuration from all tools${NC}"
  read -p "Are you sure? (y/N) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Resetting TOON setup..."

    # Remove configurations
    [ -f "$HOME/.claude/settings.json" ] && \
      sed -i '' '/contextStorage/d' "$HOME/.claude/settings.json"

    rm -rf "$HOME/.config/gemini-cli/toon-config.json"
    rm -rf "$HOME/.antigravity/toon.toml"
    rm -rf "$HOME/.ollama/toon-context.json"

    echo -e "${GREEN}✓ TOON setup reset${NC}"
  else
    echo "Reset cancelled."
  fi
}

# ============================================================================
# Full Setup (Install + Configure)
# ============================================================================

full_setup() {
  echo -e "\n${BLUE}╔══════════════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║ TOON Global Context Setup - Full Installation  ║${NC}"
  echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}\n"

  echo "This will:"
  echo "  1. Install TOON libraries and tools"
  echo "  2. Configure Claude, Gemini, agy, and Ollama"
  echo "  3. Set up context storage in TOON format"
  echo "  4. Convert existing markdown context to TOON"
  echo ""

  read -p "Continue? (Y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    install_all && configure_all && verify_setup

    echo -e "\n${BLUE}Step 4: Converting existing memory...${NC}"
    bash "$TOON_SETUP_DIR/memory-converter.sh" convert || true

    echo -e "\n${GREEN}╔═════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║ ✓ TOON Setup Complete!                         ║${NC}"
    echo -e "${GREEN}╚═════════════════════════════════════════════════╝${NC}\n"

    echo "Next steps:"
    echo "  1. Restart Claude Code for hooks to take effect"
    echo "  2. Run 'ton init' in any project to enable local memory"
    echo "  3. Run 'ton stats' to see token savings"
    echo ""
  else
    echo "Setup cancelled."
  fi
}

# ============================================================================
# Help
# ============================================================================

show_help() {
  cat << 'EOF'

┌─ TOON Global Context Setup ──────────────────────────────────────┐
│                                                                  │
│ Converts all AI tool context storage to TOON format for 60-90%  │
│ token savings across Claude, Gemini, agy, and Ollama.           │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘

USAGE:
  ton setup [command]

COMMANDS:
  (no arg)     Full setup (install + configure + verify)
  install      Install TOON libraries and utilities
  configure    Configure all AI tools for TOON context
  verify       Verify setup across all tools
  stats        Show context statistics and savings
  reset        Remove TOON configuration

AFTER SETUP — use ton:
  ton help              Show all commands
  ton init [dir]        Enable TOON in a project
  ton convert [dir]     Convert memory files to TOON
  ton stats             View token savings
  ton verify            Check setup status

EXAMPLE:
  ton setup              # Full setup
  ton setup verify       # Check status
  ton stats              # View token savings

For detailed information: https://github.com/toon-format/toon

EOF
  exit 0
}

# ============================================================================
# Run Main
# ============================================================================

if [ -z "$1" ]; then
  full_setup
else
  main "$@"
fi
