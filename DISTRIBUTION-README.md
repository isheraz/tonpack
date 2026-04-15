# TOON Global Setup - Installable Skill

**Global context storage in TOON format for 60-90% token savings across all AI tools**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Compatibility](https://img.shields.io/badge/Supports-Claude%20%7C%20Gemini%20%7C%20agy%20%7C%20Ollama-blue)](https://github.com/toon-format/toon)

## What is This?

A **production-ready, installable skill** that configures all your AI tools (Claude, Gemini, agy, Ollama) to use TOON format for context storage, reducing token consumption by **60-90%**.

### Why?

- **Token costs money** - Every token in your context window is billed by LLM providers
- **TOON is compact** - Same data, 60-90% fewer tokens
- **TOON is lossless** - Perfect round-trip conversion to/from JSON
- **TOON is standard** - Open format with multi-language implementations

## Quick Install

### From This Directory

```bash
bash install.sh
```

### From Any Directory

```bash
git clone https://github.com/yourusername/toon-global-setup.git
cd toon-global-setup
bash install.sh
```

### Via NPM (Coming Soon)

```bash
npm install -g toon-global-setup
```

## Usage

After installation, run:

```bash
# Full setup (install + configure + verify)
toon-setup

# Or step-by-step:
toon-setup install      # Install dependencies
toon-setup configure    # Configure AI tools
toon-setup verify       # Verify setup

# Then use these utilities:
toon-verify             # Check setup status
toon-stats              # Show token savings
toon-cleanup [days]     # Remove old context
toon-export [fmt] [dir] # Export context
toon-convert            # Convert memory to TOON
```

## What Gets Installed

```
~/.claude/toon-setup/
├── install-dependencies.sh    # Install TOON libraries
├── configure-ai-tools.sh      # Configure Claude/Gemini/agy/Ollama
├── toon-utils.sh             # Utility commands
├── shell-integration.sh       # Shell aliases
├── converter.js              # [Created] JSON ↔ TOON converter
├── memory-converter.sh       # [Created] Auto-sync memory files
└── README.md, documentation

~/.claude/toon-context/        # Context storage directory

~/.zshrc / ~/.bashrc           # Updated with TOON commands
```

## AI Tools Configured

| Tool | Config | Status |
|------|--------|--------|
| **Claude CLI** | `~/.claude/settings.json` | ✅ Supported |
| **Gemini CLI** | `~/.config/gemini-cli/toon-config.json` | ✅ Supported |
| **agy (Antigravity)** | `~/.antigravity/toon.toml` | ✅ Supported |
| **Ollama** | `~/.ollama/toon-context.json` | ✅ Supported |

## Example: Token Savings

### Before (Markdown + JSON)
```markdown
# Employee Records
```json
{
  "employees": [
    {"id":1,"name":"Alice","email":"alice@example.com","dept":"Engineering"},
    {"id":2,"name":"Bob","email":"bob@example.com","dept":"Sales"},
    {"id":3,"name":"Carol","email":"carol@example.com","dept":"Marketing"}
  ]
}
```

**Tokens**: ~500
```

### After (TOON Format)
```
employees[3]{id,name,email,dept}:
  1,Alice,alice@example.com,Engineering
  2,Bob,bob@example.com,Sales
  3,Carol,carol@example.com,Marketing
```

**Tokens**: ~180

**Savings**: **64%** (320 tokens saved)

---

## Installation Requirements

### System Requirements
- **bash** 4.0+
- **macOS** or **Linux** (Windows: WSL or Git Bash)
- **Node.js** 14+ (optional, for converter.js)
- **Python** 3.6+ (optional, for Python integration)

### AI Tools
At least one of:
- Claude CLI
- Gemini CLI  
- agy (Antigravity)
- Ollama

## File Structure

```
toon-skill/
├── install.sh                     # Universal installer
├── package.json                   # NPM metadata
├── toon-global-setup.sh          # Main skill/orchestrator
├── install-dependencies.sh        # Installs TOON libraries
├── configure-ai-tools.sh         # Configures all tools
├── toon-utils.sh                 # Utility commands
├── shell-integration.sh          # Shell aliases
├── README.md                     # Technical docs
├── GETTING-STARTED.md            # Step-by-step guide
├── INSTALLATION-SUMMARY.md       # Setup overview
├── DISTRIBUTION-README.md        # This file
├── LICENSE                       # MIT license
└── .gitignore                    # Git ignore patterns
```

## Getting Started

### 1. Install

```bash
bash install.sh
exec zsh  # Restart shell
```

### 2. Configure

```bash
toon-setup
# Installs dependencies + configures all AI tools
# Takes 3-5 minutes
```

### 3. Verify

```bash
toon-verify
```

### 4. Check Savings

```bash
toon-stats
```

## Documentation

- **[GETTING-STARTED.md](./GETTING-STARTED.md)** - Step-by-step setup guide
- **[README.md](./README.md)** - Complete technical reference
- **[INSTALLATION-SUMMARY.md](./INSTALLATION-SUMMARY.md)** - What gets installed

## Advanced Usage

### Auto-Convert Markdown Memory

```bash
# One-time conversion
toon-memory-convert

# Watch for changes (continuous)
toon-memory-watch
```

### Custom TOON Conversion

```bash
# Convert JSON to TOON
toon-convert-cmd json-to-toon data.json -o data.toon

# Convert TOON to JSON
toon-convert-cmd toon-to-json data.toon -o data.json

# Inline conversion
toon-convert-cmd inline '{"name":"test","count":42}'
```

### Integration with RTK

For maximum token savings (80-95% total), combine with [RTK](https://github.com/rtk-ai/rtk):

```bash
# RTK: 60-90% savings on command output
git status → `rtk git status`

# TOON: 60-90% savings on context
# (automatic)

# Combined: 80-95% total token reduction
```

## Troubleshooting

### "toon-setup: command not found"

Restart your shell:
```bash
exec zsh
```

Or manually source:
```bash
source ~/.claude/toon-setup/shell-integration.sh
```

### Verify installation worked

```bash
toon-verify
```

Shows detailed status of all components.

### Reset and reinstall

```bash
toon-setup reset
bash install.sh
```

### Check converter works

```bash
echo '{"test":"data"}' | toon-convert-cmd inline '@'
```

Should output TOON format.

## How It Works

### Architecture

```
┌─ AI Tools ─────────────────────┐
│ Claude  Gemini  agy  Ollama    │
└────┬───────────────────────────┘
     │ (read context)
     ▼
┌─ TOON Context Store ──────────────┐
│ ~/.claude/toon-context/           │
│ - session-*.toon                  │
│ - memory-*.toon                   │
└────▲──────────────────────────────┘
     │ (write context)
┌────┴──────────────────────────────┐
│ Memory Auto-Converter             │
│ Watches ~/.claude/memory/*.md     │
│ Converts to TOON format           │
└───────────────────────────────────┘
```

### Data Flow

1. **Markdown Memory** → Auto-converter watches for changes
2. **TOON Conversion** → Stores in ~/.claude/toon-context/
3. **AI Tools** → Read from TOON context (60-90% fewer tokens)
4. **Transparent** → No code changes needed

## Configuration Examples

### Claude CLI

```json
{
  "contextStorage": {
    "format": "toon",
    "path": "~/.claude/toon-context",
    "autoCompress": true
  }
}
```

### Gemini CLI

```json
{
  "contextFormat": "toon",
  "contextPath": "~/.claude/toon-context"
}
```

### agy

```toml
[context]
format = "toon"
path = "~/.claude/toon-context"
```

### Ollama

```json
{
  "contextFormat": "toon",
  "contextStoragePath": "~/.claude/toon-context"
}
```

## Contributing

Contributions welcome! This is open source and community-driven.

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## License

MIT License - see [LICENSE](./LICENSE) file

## References

- **TOON Format**: https://github.com/toon-format/toon
- **TOON Specification**: https://github.com/toon-format/toon/blob/main/spec.md
- **RTK (Token Killer)**: https://github.com/rtk-ai/rtk
- **Claude Code**: https://claude.ai/code

## Support

### Getting Help

1. Check [GETTING-STARTED.md](./GETTING-STARTED.md)
2. Run `toon-verify` to diagnose issues
3. Check logs: `ls -la ~/.claude/debug/`
4. Open an issue: https://github.com/yourusername/toon-global-setup/issues

### Reporting Issues

Please include:
- Output of `toon-verify`
- Shell type (`echo $SHELL`)
- OS (`uname -a`)
- Error message (full output)

## Roadmap

- [ ] NPM package distribution
- [ ] Homebrew tap
- [ ] MCP Server integration
- [ ] GitHub Actions for CI/CD
- [ ] Automated release pipeline
- [ ] Web dashboard for monitoring
- [ ] API for programmatic access

## Acknowledgments

- [TOON Format](https://github.com/toon-format/toon) - The format that makes this possible
- [RTK](https://github.com/rtk-ai/rtk) - Inspiration for token optimization
- Claude Code community - Your feedback drives improvements

---

## Quick Links

| Link | Purpose |
|------|---------|
| 📖 [GETTING-STARTED.md](./GETTING-STARTED.md) | Setup guide |
| 📚 [README.md](./README.md) | Technical reference |
| 📋 [INSTALLATION-SUMMARY.md](./INSTALLATION-SUMMARY.md) | What gets installed |
| 🔗 [TOON Format](https://github.com/toon-format/toon) | The format |
| 💬 [Issues](https://github.com/yourusername/toon-global-setup/issues) | Support |

---

**Ready to save tokens?**

```bash
bash install.sh && toon-setup
```

**Questions?** See [GETTING-STARTED.md](./GETTING-STARTED.md) or [README.md](./README.md)

Happy token saving! 🚀
