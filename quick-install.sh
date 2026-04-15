#!/bin/bash

# TOON Global Setup - Quick Install
# One-command installation and setup

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "\n${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║ TOON Global Setup - Quick Install             ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}\n"

echo "This will:"
echo "  1. Install TOON to ~/.claude/toon-setup/"
echo "  2. Configure Claude, Gemini, agy, and Ollama"
echo "  3. Set up global commands"
echo "  4. Convert existing memory to TOON"
echo ""

read -p "Continue? (Y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
  echo "Installation cancelled."
  exit 1
fi

# Step 1: Install
echo -e "\n${BLUE}Step 1: Installing TOON to ~/.claude/toon-setup/${NC}"
bash "$SCRIPT_DIR/install.sh" install || exit 1

# Step 2: Verify installation
echo -e "\n${BLUE}Step 2: Verifying installation${NC}"
bash "$SCRIPT_DIR/install.sh" verify || exit 1

# Step 3: Reload shell integration
echo -e "\n${BLUE}Step 3: Reloading shell integration${NC}"
source ~/.claude/toon-setup/shell-integration.sh 2>/dev/null || true

# Step 4: Run full setup
echo -e "\n${BLUE}Step 4: Running full setup (install + configure)${NC}"
bash ~/.claude/toon-setup/toon-global-setup.sh || {
  echo -e "${YELLOW}⚠ Setup script failed. You can run 'toon-setup' manually later.${NC}"
}

echo -e "\n${GREEN}╔════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║ ✓ Installation Complete!                      ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════╝${NC}\n"

echo "Next steps:"
echo "  1. Restart Claude Code: close and reopen the application"
echo "  2. Check token savings: toon-stats"
echo "  3. Verify setup: toon-verify"
echo ""
echo -e "Documentation:"
echo "  - Getting started: $SCRIPT_DIR/GETTING-STARTED.md"
echo "  - Full reference: $SCRIPT_DIR/README.md"
echo ""
