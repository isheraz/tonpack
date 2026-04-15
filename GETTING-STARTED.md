# TOON Global Setup - Getting Started Guide

Welcome! This guide will walk you through setting up TOON format context storage across all your AI tools.

## What You've Been Set Up With

A complete TOON Global Context system that includes:

### ✅ Installed Components
- **Shell Integration** (`shell-integration.sh`) - Global command aliases
- **Main Setup Skill** (`/Users/sheraz/.claude/skills/toon-global-setup.sh`)
- **Install Script** (`install-dependencies.sh`) - Installs TOON libraries
- **Configuration Script** (`configure-ai-tools.sh`) - Configures all AI tools
- **Utility Tools** (`toon-utils.sh`) - Management commands
- **Documentation** (this file + README.md)

### ✅ Available Commands (Right Now!)

All these commands are ready to use:

```bash
# Main command
toon-setup                  # Run full setup (or with arguments below)

# Utilities (after full setup completes)
toon-verify                 # Check setup status
toon-stats                  # Show context statistics
toon-cleanup               # Remove old context files
toon-export                # Export context in various formats
toon-convert               # Convert markdown memory to TOON
toon-memory-watch          # Watch for auto-sync
```

## Getting Started - 3 Steps

### Step 1: Run Full Setup

```bash
toon-setup
```

This will:
1. ✓ Install TOON libraries (Node, Python, Go, Rust)
2. ✓ Create converter.js utility
3. ✓ Configure Claude CLI (~/.claude/settings.json)
4. ✓ Configure Gemini CLI (~/.config/gemini-cli/)
5. ✓ Configure agy (~/.antigravity/)
6. ✓ Configure Ollama (~/.ollama/)
7. ✓ Set up context directory (~/.claude/toon-context/)
8. ✓ Create memory auto-converter
9. ✓ Verify everything works

Expected time: 2-3 minutes

### Step 2: Verify Success

```bash
toon-verify
```

This shows:
- Installation status (Node, Python, Go, Rust)
- AI tool status (Claude, Gemini, agy, Ollama)
- Configuration status (all 4 tools)
- Utility status (converter, directories, memory service)

Expected output: All green ✓

### Step 3: (Optional) Convert Existing Memory

If you have existing markdown memory files:

```bash
toon-memory-convert
```

This converts all `~/.claude/memory/*.md` files to TOON format in `~/.claude/toon-context/`

## How It Works

### Context Flow

```
1. Your Markdown Memory
   └─> ~/.claude/memory/*.md

2. Auto-Converter (runs automatically)
   └─> Watches for changes
   └─> Converts to TOON format

3. TOON Context Store
   └─> ~/.claude/toon-context/*.toon

4. AI Tools Use TOON
   └─> Claude CLI
   └─> Gemini CLI
   └─> agy
   └─> Ollama
   └─> (60-90% fewer tokens!)
```

### What Gets Compressed

Any structured data in your context:
- **Memory files** (user info, project context, preferences)
- **Session history** (conversation snapshots)
- **Configuration data** (tool settings, preferences)
- **Knowledge bases** (lists, tables, catalogs)

### Token Savings Example

Before setup:
```markdown
# Employee Data
```json
{
  "employees": [
    {"id": 1, "name": "Alice", "dept": "Eng", "salary": 95000},
    {"id": 2, "name": "Bob", "dept": "Sales", "salary": 75000}
  ]
}
```
**Token cost**: ~350 tokens
```

After setup:
```
employees[2]{id,name,dept,salary}:
  1,Alice,Eng,95000
  2,Bob,Sales,75000
```
**Token cost**: ~140 tokens

**Savings**: 60%

---

## Daily Usage (After Setup)

Everything is **automatic** after setup. Nothing to remember!

- ✅ Markdown memory auto-converts to TOON
- ✅ AI tools use TOON automatically
- ✅ Token savings apply transparently
- ✅ Full round-trip conversion (no data loss)

## Checking Progress

```bash
# See token savings
toon-stats

# Check conversion status
toon-verify

# Monitor memory conversion (real-time)
toon-memory-watch
```

## Troubleshooting

### "toon-setup command not found"

Restart your shell:

```bash
exec zsh
```

Or manually load the integration:

```bash
source ~/.claude/toon-setup/shell-integration.sh
```

### Setup fails on configure step

Check what's missing:

```bash
toon-verify
```

This will show which AI tools/configs are problematic.

### Want to reset and start over

```bash
toon-setup reset
```

Then run `toon-setup` again.

### Converter not working

Test it:

```bash
echo '{"name":"test","age":30}' | toon-setup | grep "items"
```

Should output TOON format.

## Understanding TOON Format

### JSON to TOON Conversion

**JSON** (verbose for LLMs):
```json
{
  "users": [
    {"id": 1, "name": "Alice"},
    {"id": 2, "name": "Bob"}
  ]
}
```

**TOON** (compact for LLMs):
```
users[2]{id,name}:
  1,Alice
  2,Bob
```

### Key Principles

- **Indentation = nesting** (like YAML)
- **Tables = uniform arrays** (like CSV)
- **No quotes = no punctuation** (less noise)
- **Explicit schema** (helps LLMs parse reliably)

## Advanced Topics

### Combining with RTK

For maximum token savings (80-95% total):

```bash
# RTK: Compress command output (60-90% savings)
rtk git status
rtk cargo test

# TOON: Compress context storage (60-90% savings)
# (Happens automatically after setup)

# Total: 80-95% token reduction on most workflows
```

### Custom TOON Conversion

Use `converter.js` directly:

```bash
# Convert JSON file to TOON
toon-convert-cmd json-to-toon mydata.json -o mydata.toon

# Convert back
toon-convert-cmd toon-to-json mydata.toon -o mydata.json

# Extract JSON from markdown and convert
toon-convert-cmd md-to-toon notes.md -o notes.toon

# Inline conversion
toon-convert-cmd inline '{"key":"value"}'
```

### Monitoring & Cleanup

```bash
# Show detailed statistics
toon-stats

# Remove old context (older than 30 days)
toon-cleanup 30

# Remove really old stuff (older than 90 days)
toon-cleanup 90

# Export for backup
toon-export json ~/backups/toon-export
```

## Architecture (For Developers)

```
~/.claude/
├── toon-setup/
│   ├── README.md                    # Full documentation
│   ├── GETTING-STARTED.md          # This file
│   ├── converter.js                 # Created by install script
│   ├── memory-converter.sh          # Created by configure script
│   ├── install-dependencies.sh      # Install TOON libraries
│   ├── configure-ai-tools.sh        # Configure all AI tools
│   ├── toon-utils.sh               # Utility commands
│   ├── shell-integration.sh        # Global aliases (in ~/.zshrc)
│   └── hooks/
│       └── save-context-toon.sh    # Created by configure script

~/.claude/skills/
└── toon-global-setup.sh            # Main setup skill

~/.claude/toon-context/             # Context storage (TOON files)
├── session-*.toon                  # Session snapshots
├── memory-*.toon                   # Converted memory files
└── ...
```

## Files Modified During Setup

When you run `toon-setup`, these files are created/modified:

1. **~/.claude/settings.json** - Added `contextStorage` section
2. **~/.config/gemini-cli/toon-config.json** - Created
3. **~/.antigravity/toon.toml** - Created
4. **~/.ollama/toon-context.json** - Created
5. **~/.zshrc** - Added TOON shell integration source

## References

- **TOON Format Spec**: https://github.com/toon-format/toon
- **RTK (Token Killer)**: https://github.com/rtk-ai/rtk
- **Claude Code**: https://claude.ai/code

## Next Steps

1. **Run setup**: `toon-setup`
2. **Verify**: `toon-verify`
3. **Restart Claude Code** for hooks to activate
4. **Watch savings grow**: `toon-stats`

---

**Questions?** Run `toon-setup --help` or check `README.md`

**Ready?** Run `toon-setup` now! 🚀
