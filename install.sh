#!/bin/bash

# TOON Global Setup - Universal Installer
# Installs TOON (Token-Oriented Object Notation) global context setup
# Works from any directory - automatically handles paths

set -e

# Detect installation directory
INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOON_SETUP_DIR="${HOME}/.claude/toon-setup"
TOON_CONTEXT_DIR="${HOME}/.claude/toon-context"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# ============================================================================
# Main Installation
# ============================================================================

main() {
  local action="${1:-install}"

  case "$action" in
    install|setup)
      full_install
      ;;
    verify)
      verify_install
      ;;
    uninstall)
      uninstall_setup
      ;;
    *)
      show_help
      ;;
  esac
}

# ============================================================================
# Full Installation
# ============================================================================

full_install() {
  echo -e "\n${BLUE}╔════════════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║ TOON Global Setup - Installation               ║${NC}"
  echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}\n"

  echo "Installation source: $INSTALL_DIR"
  echo "Installation target: $TOON_SETUP_DIR"
  echo ""

  # Create target directory
  mkdir -p "$TOON_SETUP_DIR"
  mkdir -p "$TOON_CONTEXT_DIR"

  # Copy all files
  echo -e "${BLUE}Copying files...${NC}"
  cp "$INSTALL_DIR"/*.sh "$TOON_SETUP_DIR/" 2>/dev/null || true
  cp "$INSTALL_DIR"/*.js "$TOON_SETUP_DIR/" 2>/dev/null || true
  cp "$INSTALL_DIR"/*.md "$TOON_SETUP_DIR/" 2>/dev/null || true
  cp "$INSTALL_DIR/ton" "$TOON_SETUP_DIR/ton" 2>/dev/null || true
  chmod +x "$TOON_SETUP_DIR"/*.sh "$TOON_SETUP_DIR/ton" 2>/dev/null || true

  echo -e "${GREEN}✓ Files copied${NC}"

  # Copy main skill if in Claude skills directory
  if [ -d "$HOME/.claude/skills" ]; then
    echo -e "${BLUE}Installing main skill...${NC}"
    cat > "$HOME/.claude/skills/toon-global-setup.sh" << 'SKILLEOF'
#!/bin/bash

# TOON Global Setup Skill
# Main entry point for TOON context setup

TOON_SETUP_DIR="$HOME/.claude/toon-setup"

if [ ! -f "$TOON_SETUP_DIR/toon-global-setup.sh" ]; then
  echo "Error: TOON setup not installed. Run: bash $TOON_SETUP_DIR/install.sh"
  exit 1
fi

bash "$TOON_SETUP_DIR/toon-global-setup.sh" "$@"
SKILLEOF
    chmod +x "$HOME/.claude/skills/toon-global-setup.sh"
    echo -e "${GREEN}✓ Skill installed${NC}"
  fi

  # Setup shell integration
  echo -e "${BLUE}Setting up shell integration...${NC}"
  setup_shell_integration

  echo -e "\n${GREEN}✓ Installation complete!${NC}\n"

  echo -e "${BLUE}Next steps:${NC}"
  echo "  1. Restart your shell:  exec zsh"
  echo "  2. Run full setup:      ton setup"
  echo "  3. Verify installation: ton verify"
  echo ""
  echo -e "${YELLOW}Quick reference:${NC}"
  echo "  ton help    - Show all commands"
  echo "  ton setup   - Run full setup"
  echo "  ton stats   - Show token savings"
  echo "  ton convert - Convert memory to TOON"
  echo ""
}

# ============================================================================
# Shell Integration
# ============================================================================

setup_shell_integration() {
  local shell_rc=""

  if [ -f "$HOME/.zshrc" ]; then
    shell_rc="$HOME/.zshrc"
  elif [ -f "$HOME/.bashrc" ]; then
    shell_rc="$HOME/.bashrc"
  else
    echo -e "${YELLOW}⚠ No shell RC file found. Skipping shell integration.${NC}"
    return 1
  fi

  # Check if already integrated
  if grep -q "toon-setup/shell-integration.sh" "$shell_rc"; then
    echo -e "${GREEN}✓ Already integrated in $shell_rc${NC}"
    return 0
  fi

  # Add integration
  cat >> "$shell_rc" << 'RCEOF'

# TOON Global Setup - Token-Oriented Object Notation context storage
source "$HOME/.claude/toon-setup/shell-integration.sh" 2>/dev/null || true
RCEOF

  echo -e "${GREEN}✓ Integrated into $shell_rc${NC}"
}

# ============================================================================
# Verify Installation
# ============================================================================

verify_install() {
  echo -e "\n${BLUE}Verifying TOON installation...${NC}\n"

  if [ ! -d "$TOON_SETUP_DIR" ]; then
    echo -e "${RED}✗ Setup directory not found: $TOON_SETUP_DIR${NC}"
    echo -e "${YELLOW}Run: bash $INSTALL_DIR/install.sh${NC}"
    return 1
  fi

  echo -e "${GREEN}✓ Setup directory: $TOON_SETUP_DIR${NC}"
  echo -e "${GREEN}✓ Context directory: $TOON_CONTEXT_DIR${NC}"

  # Check components
  local missing=0
  for component in install-dependencies.sh configure-ai-tools.sh toon-utils.sh shell-integration.sh ton; do
    if [ -f "$TOON_SETUP_DIR/$component" ]; then
      echo -e "${GREEN}✓ $component${NC}"
    else
      echo -e "${RED}✗ $component${NC}"
      missing=$((missing + 1))
    fi
  done

  if [ $missing -eq 0 ]; then
    echo -e "\n${GREEN}✓ Installation verified successfully!${NC}"
    echo -e "${BLUE}Run: toon-setup${NC}"
    return 0
  else
    echo -e "\n${RED}✗ Some components missing. Reinstall: bash $INSTALL_DIR/install.sh${NC}"
    return 1
  fi
}

# ============================================================================
# Uninstall
# ============================================================================

uninstall_setup() {
  echo -e "${YELLOW}⚠ This will remove TOON setup${NC}"
  read -p "Are you sure? (y/N) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "$TOON_SETUP_DIR"
    rm -f "$HOME/.claude/skills/toon-global-setup.sh"
    echo -e "${GREEN}✓ TOON setup removed${NC}"
  else
    echo "Uninstall cancelled."
  fi
}

# ============================================================================
# Help
# ============================================================================

show_help() {
  cat << 'EOF'

TOON Global Setup - Installer

USAGE:
  bash install.sh [command]

COMMANDS:
  install     Install TOON globally (default)
  verify      Verify installation
  uninstall   Remove TOON setup

EXAMPLES:
  bash install.sh              # Full installation
  bash install.sh verify       # Check installation
  bash install.sh uninstall    # Remove TOON

AFTER INSTALLATION:
  ton setup    # Run full setup
  ton verify   # Check status
  ton stats    # Show token savings

For more info: https://github.com/toon-format/toon

EOF
  exit 0
}

# ============================================================================
# Run
# ============================================================================

main "$@"
