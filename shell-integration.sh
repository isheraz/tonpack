#!/bin/bash

# TOON Shell Integration - Add to ~/.zshrc or ~/.bashrc
# This file provides global toon-* command aliases

TOON_SETUP_DIR="$HOME/.claude/toon-setup"
TOON_SKILLS_DIR="$HOME/.claude/skills"

# ============================================================================
# Global TOON Commands (aliases and functions)
# ============================================================================

alias ton='bash '"$TOON_SETUP_DIR"'/ton'

# ============================================================================
# Export for shell initialization
# ============================================================================

# This script should be sourced in ~/.zshrc or ~/.bashrc

export TOON_SETUP_DIR
export TOON_SKILLS_DIR
export PATH="$TOON_SETUP_DIR:$PATH"

