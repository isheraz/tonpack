# 🚀 TOON Global Setup - Start Here

Welcome! You have the **complete TOON Global Setup Skill** ready to install and share.

## What You Have

A production-ready, shareable installation package for TOON (Token-Oriented Object Notation) context storage across all AI tools.

```
toon-skill/
├── quick-install.sh              ← 🟢 START HERE - One-command install
├── install.sh                    ← Alternative: step-by-step installer
├── package.json                  ← NPM package metadata
├── LICENSE                       ← MIT License (shareable!)
├── .gitignore                    ← Git configuration
│
├── 📖 Documentation:
│   ├── START-HERE.md            ← This file
│   ├── DISTRIBUTION-README.md   ← For sharing (GitHub, NPM, etc)
│   ├── GETTING-STARTED.md       ← Setup guide
│   ├── README.md                ← Technical reference
│   └── INSTALLATION-SUMMARY.md  ← What gets installed
│
└── 🔧 Installation Scripts:
    ├── toon-global-setup.sh     ← Main orchestrator
    ├── install-dependencies.sh  ← Installs TOON libraries
    ├── configure-ai-tools.sh    ← Configures Claude/Gemini/agy/Ollama
    ├── toon-utils.sh           ← Utility commands
    └── shell-integration.sh    ← Shell aliases
```

## ⚡ Quick Install (2 minutes)

```bash
bash quick-install.sh
```

That's it! This will:
1. ✅ Install to ~/.claude/toon-setup/
2. ✅ Configure all AI tools
3. ✅ Set up shell commands
4. ✅ Show you your token savings

## 📦 Locations

- **Installation source**: `/Users/sheraz/work/mics/toon-skill/` ← You are here
- **Global installation**: `~/.claude/toon-setup/` ← After running quick-install.sh
- **Context storage**: `~/.claude/toon-context/` ← TOON files go here

## 🎯 Commands After Installation

```bash
toon-setup              # Full setup (or step-by-step)
toon-verify             # Check setup status
toon-stats              # Show token savings
toon-cleanup [days]     # Remove old context
toon-export [fmt] [dir] # Export context
toon-convert            # Convert memory to TOON
```

## 💡 What It Does

- **Reduces token consumption** by 60-90% on all structured context
- **Works globally** - applies to Claude, Gemini, agy, and Ollama
- **Completely transparent** - automatic, no code changes needed
- **Fully reversible** - perfect lossless JSON ↔ TOON conversion

## 📊 Example Savings

### Before (Markdown + JSON)
```markdown
employees: [{id:1,name:Alice,dept:Eng},{id:2,name:Bob,dept:Sales}]
```
**Tokens**: ~200

### After (TOON)
```
employees[2]{id,name,dept}:
  1,Alice,Eng
  2,Bob,Sales
```
**Tokens**: ~70

**Savings**: 65%

---

## 🚀 Getting Started

### Option 1: One-Command Install (Recommended)
```bash
bash quick-install.sh
```

### Option 2: Manual Install
```bash
bash install.sh
exec zsh                    # Restart shell
toon-setup                  # Run full setup
```

### Option 3: Verify First
```bash
bash install.sh verify      # Check if installation works
```

## 📖 Documentation

| File | Purpose | Read Time |
|------|---------|-----------|
| **[DISTRIBUTION-README.md](./DISTRIBUTION-README.md)** | Share this with others | 5 min |
| **[GETTING-STARTED.md](./GETTING-STARTED.md)** | Step-by-step setup guide | 10 min |
| **[README.md](./README.md)** | Complete technical reference | 20 min |
| **[INSTALLATION-SUMMARY.md](./INSTALLATION-SUMMARY.md)** | What gets installed | 5 min |

## 🔄 Sharing This Skill

This folder is ready to be shared as-is!

### Via Git
```bash
git init
git add .
git commit -m "Initial commit: TOON Global Setup"
git remote add origin https://github.com/yourusername/toon-global-setup.git
git push -u origin main
```

### Via NPM
Update `package.json` with your info, then:
```bash
npm publish
# Now installable globally via: npm install -g toon-global-setup
```

### Via Download
Users can simply download and run:
```bash
bash quick-install.sh
```

## ✅ Pre-Configured For

- ✅ Claude CLI
- ✅ Gemini CLI
- ✅ agy (Antigravity)
- ✅ Ollama
- ✅ Integration with RTK (Token Killer)

## 🆘 Troubleshooting

### "quick-install.sh not found"
Make sure you're in the toon-skill directory:
```bash
cd /Users/sheraz/work/mics/toon-skill
bash quick-install.sh
```

### Commands not found after install
Restart your shell:
```bash
exec zsh
```

### Need to check status
```bash
toon-verify
```

### Want to reset
```bash
toon-setup reset
bash quick-install.sh  # Reinstall
```

## 📋 Checklist

Before sharing:
- [ ] Read DISTRIBUTION-README.md
- [ ] Update package.json with your info
- [ ] Add your GitHub URL to package.json
- [ ] Update LICENSE (or use MIT as-is)
- [ ] Test: `bash quick-install.sh`
- [ ] Commit to git
- [ ] Push to GitHub/publish to NPM

## 🔗 Links

- **TOON Format**: https://github.com/toon-format/toon
- **RTK**: https://github.com/rtk-ai/rtk
- **Claude Code**: https://claude.ai/code

## ❓ Questions?

1. **Getting started?** → Read [GETTING-STARTED.md](./GETTING-STARTED.md)
2. **Technical details?** → Read [README.md](./README.md)
3. **Want to share?** → Use [DISTRIBUTION-README.md](./DISTRIBUTION-README.md)
4. **Need help?** → Run `toon-verify` to diagnose issues

## 🎉 Ready?

```bash
bash quick-install.sh
```

Then restart Claude Code and run `toon-stats` to see your token savings!

---

**Questions?** Check the docs or run `toon-setup --help` after installation.

**Happy token saving!** 🚀
