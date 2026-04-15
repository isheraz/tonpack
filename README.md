# TOON Global Context Setup

**Convert all AI tool context storage (Claude, Gemini, agy, Ollama) to TOON format for 60-90% token savings**

## What is TOON?

[Token-Oriented Object Notation](https://github.com/toon-format/toon) is a compact, human-readable encoding format designed specifically for LLM input. It combines YAML-style indentation with CSV-like tabular layouts, reducing token consumption by 60% while maintaining lossless round-trip conversion to JSON.

### Why Use TOON?

- **60-90% token reduction** on structured data
- **Lower LLM API costs** (pay less per token)
- **Better model accuracy** (explicit schema declarations help LLMs parse better)
- **Human-readable** (not opaque binary format)
- **Lossless conversion** (perfect round-trip to/from JSON)

## Installation

### Quick Start

```bash
# Full setup (install + configure + verify)
toon-setup

# Or step-by-step:
toon-setup install      # Install TOON libraries
toon-setup configure    # Configure all AI tools
toon-setup verify       # Verify setup complete
```

### What Gets Installed

1. **TOON Libraries** for Node.js, Python, Go, Rust
2. **Converter Utility** (converter.js) - JSON ↔ TOON conversion
3. **Memory Converter** - Auto-converts markdown memory to TOON
4. **Configuration** for Claude, Gemini, agy, Ollama
5. **Context Directory** (~/.claude/toon-context) - centralized storage

## How It Works

### Architecture

```
┌─ Your AI Tools ──────────────────────┐
│                                      │
│ Claude CLI    Gemini CLI   agy Ollama│
│      │             │         │   │    │
└──────┼─────────────┼─────────┼───┼────┘
       │             │         │   │
       └─────────────┴─────────┴───┘
            (hooks + config)
                  │
       ┌──────────▼──────────┐
       │  Memory Converter   │  Watches ~/.claude/memory/
       │  (auto-sync)        │  Converts .md → .toon
       └──────────┬──────────┘
                  │
       ┌──────────▼──────────────┐
       │  TOON Context Store     │  ~/.claude/toon-context/
       │  (centralized)          │
       │  - Structured data      │
       │  - Session memory       │
       │  - Context cache        │
       └─────────────────────────┘
```

### Data Flow

1. **Store**: Markdown memory → TOON (memory-converter watches changes)
2. **Serve**: AI tools read from `.toon-context/` in TOON format
3. **Convert**: On-demand conversion via `toon-converter` utility
4. **Sync**: Auto-sync between markdown and TOON formats

## Global Commands

After setup, use these commands globally:

```bash
# Setup & verification
toon-setup                  # Full setup (default)
toon-setup install          # Install dependencies only
toon-setup configure        # Configure AI tools only
toon-setup verify           # Check if setup is complete
toon-setup reset            # Remove TOON configuration

# Utility commands
toon-verify                 # Verify setup across all tools
toon-stats                  # Show context statistics & token savings
toon-cleanup [days]         # Remove old context files (default: 30 days)
toon-export [format] [dir]  # Export as json/toon/md (default: json, ./export)
toon-convert                # Convert markdown memory files to TOON

# Memory management
toon-memory-convert         # One-time convert all markdown to TOON
toon-memory-watch           # Watch for changes and auto-convert

# Direct converter
toon-convert-cmd            # Direct access to converter.js
```

## Configuration Details

### Claude CLI (~/.claude/settings.json)

```json
{
  "contextStorage": {
    "format": "toon",
    "path": "~/.claude/toon-context",
    "autoCompress": true
  },
  "hooks": {
    "Stop": [
      { "hooks": [{ "type": "command", "command": "~/.claude/toon-setup/hooks/save-context-toon.sh" }] }
    ]
  }
}
```

### Gemini CLI (~/.config/gemini-cli/toon-config.json)

```json
{
  "contextFormat": "toon",
  "contextPath": "~/.claude/toon-context",
  "hooks": { "beforeToolUse": "rtk hook gemini" }
}
```

### agy (~/.antigravity/toon.toml)

```toml
[context]
format = "toon"
path = "~/.claude/toon-context"

[serialization]
strategy = "toon"
```

### Ollama (~/.ollama/toon-context.json)

```json
{
  "contextFormat": "toon",
  "contextStoragePath": "~/.claude/toon-context"
}
```

## Token Savings Example

### Before (Markdown JSON)

```markdown
# Employee Records
```json
{
  "employees": [
    {
      "id": 1,
      "name": "Alice",
      "department": "Engineering",
      "salary": 95000
    },
    {
      "id": 2,
      "name": "Bob",
      "department": "Sales",
      "salary": 75000
    }
  ]
}
```

**Token Cost**: ~450 tokens
```

### After (TOON)

```
employees[2]{id,name,department,salary}:
  1,Alice,Engineering,95000
  2,Bob,Sales,75000
```

**Token Cost**: ~180 tokens

**Savings**: 60%

## File Structure

```
~/.claude/toon-setup/
├── README.md                          # This file
├── converter.js                        # JSON ↔ TOON converter utility
├── install-dependencies.sh            # Install TOON libraries
├── configure-ai-tools.sh              # Configure Claude/Gemini/agy/Ollama
├── toon-utils.sh                      # Utility commands (stats, cleanup, etc)
├── memory-converter.sh                # Auto-convert markdown to TOON
├── shell-integration.sh               # Global command aliases
├── hooks/
│   └── save-context-toon.sh          # Hook: save context on session end
└── README.md

~/.claude/toon-context/
├── session-1713000000.toon           # Session memory snapshots
├── memory-user.toon                  # User info (converted from .md)
├── memory-project.toon               # Project context (converted)
└── ...
```

## Converter.js Usage

```bash
# Convert JSON file to TOON
toon-convert-cmd json-to-toon data.json -o data.toon

# Convert TOON back to JSON
toon-convert-cmd toon-to-json data.toon -o data.json

# Extract JSON from markdown and convert to TOON
toon-convert-cmd md-to-toon notes.md -o notes.toon

# Inline conversion
toon-convert-cmd inline '{"name":"Alice","age":30}'

# With options
toon-convert-cmd json-to-toon data.json -o data.toon --compact
```

## Workflow Examples

### 1. Initial Setup

```bash
# Install all dependencies
toon-setup install

# Configure all AI tools
toon-setup configure

# Verify everything is working
toon-setup verify

# Convert existing markdown memory to TOON (one-time)
toon-memory-convert
```

### 2. Daily Usage

Once configured, everything is **automatic**:

- Claude Code reads context from `~/.claude/toon-context/` (TOON format)
- Markdown memory changes auto-sync to TOON via memory-converter
- Token savings apply transparently to all prompts

### 3. Maintenance

```bash
# Check token savings
toon-stats

# Clean up old context files monthly
toon-cleanup 30

# Export context for backup
toon-export json ./backups/context-backup

# Monitor memory auto-conversion
toon-memory-watch
```

## Troubleshooting

### "toon-setup command not found"

Add to `~/.zshrc` or `~/.bashrc`:

```bash
source ~/.claude/toon-setup/shell-integration.sh
```

Then restart shell.

### Verify setup issues

```bash
toon-setup verify
```

This will show which components are missing or misconfigured.

### Manual reset

```bash
# Remove TOON configuration
toon-setup reset

# Reinstall
toon-setup
```

### Check converter works

```bash
echo '{"name":"test"}' | toon-convert-cmd inline '@'
```

Should output TOON format.

## Advanced Configuration

### Custom memory sync interval

Edit `~/.claude/toon-setup/memory-converter.sh`:

```bash
# Change this to watch directory more/less frequently
fswatch -r "$MEMORY_DIR" | while read changed_file; do
  # Conversion happens here
done
```

### Modify compression threshold

Edit `~/.claude/settings.json`:

```json
{
  "contextStorage": {
    "autoCompress": true,
    "compressThreshold": 100000  // Compress when >100KB
  }
}
```

### Integration with RTK

TOON works perfectly with [RTK](https://github.com/rtk-ai/rtk) for additional 60-90% token savings on command output:

```bash
# RTK reduces command output tokens
git status  # → rtk git status (90% compression)

# TOON reduces context storage tokens
# Both active = 80-95% total token reduction!
```

## Performance Notes

- **TOON Parsing**: Fast (microseconds for typical contexts)
- **Memory Conversion**: Background process (fswatch-based)
- **Storage**: TOON files are 40-60% smaller than JSON
- **Compatibility**: 100% lossless round-trip conversion

## Best Practices

1. **Let it auto-sync** - Don't manually manage conversions
2. **Monitor with `toon-stats`** - Track savings over time
3. **Export regularly** - `toon-export json ./backups` for safety
4. **Combine with RTK** - Get 80-95% total token savings
5. **Clean up monthly** - `toon-cleanup 30` removes old sessions

## References

- **TOON Format**: https://github.com/toon-format/toon
- **TOON Specification**: https://github.com/toon-format/toon/blob/main/spec.md
- **RTK Integration**: https://github.com/rtk-ai/rtk
- **Claude Code**: https://claude.ai/code

## Support

For issues or questions:

1. Run `toon-setup verify` to check status
2. Check logs in `~/.claude/debug/`
3. Review configuration in `toon-setup verify` output
4. Open issue at https://github.com/toon-format/toon/issues

---

**Happy token saving!** 🚀

Start with: `toon-setup`
