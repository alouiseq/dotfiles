# Dotfiles - Claude Code Resources

This repo contains reusable agents, templates, and scripts for Claude Code.

---

## Scripts

| Script | Description |
|--------|-------------|
| [dev-launcher-mac.sh](scripts/dev-launcher-mac.sh) | Dev environment launcher for macOS (iTerm2 native tabs/panes) |
| [dev-launcher-linux.sh](scripts/dev-launcher-linux.sh) | Dev environment launcher for Linux/WSL (tmux sessions) |

---

## Agents

Specialized agent prompts for specific tasks.

| Agent | Description |
|-------|-------------|
| [MARKETING_AGENT](agents/MARKETING_AGENT.md) | Marketing strategy and content creation |
| [UTM_BUILDER](agents/UTM_BUILDER.md) | Generate UTM tracking parameters |

**Usage:** Reference in conversation or copy to project's CLAUDE.md

---

## Templates

### Product & Validation

| Template | Description |
|----------|-------------|
| [PRODUCT_RESEARCH](templates/PRODUCT_RESEARCH.md) | Framework for validating product ideas before building |
| [SCHOOL_COMMS_VALIDATION](templates/SCHOOL_COMMS_VALIDATION.md) | Validation plan for school communications app |
| [SCHOOL_COMMS_INTERVIEW_GUIDE](templates/SCHOOL_COMMS_INTERVIEW_GUIDE.md) | Parent interview questions (print-friendly) |
| [SCHOOL_COMMS_TRACKING.csv](templates/SCHOOL_COMMS_TRACKING.csv) | Google Sheets tracking template |

### Security

| Template | Description |
|----------|-------------|
| [SECURITY_AUDIT_TEMPLATE](templates/SECURITY_AUDIT_TEMPLATE.md) | Security audit checklist for web apps |

### Marketing

| Template | Description |
|----------|-------------|
| [PROMOTION_GUIDE](templates/marketing/PROMOTION_GUIDE.md) | General promotion strategy guide |
| [REDDIT_BLUEPRINT](templates/marketing/REDDIT_BLUEPRINT.md) | Reddit marketing playbook |
| [X_TWITTER_BLUEPRINT](templates/marketing/X_TWITTER_BLUEPRINT.md) | X/Twitter marketing playbook |
| [INDIE_HACKERS_BLUEPRINT](templates/marketing/INDIE_HACKERS_BLUEPRINT.md) | Indie Hackers community marketing |

---

## How to Use

### Reference directly:
```
"Use the PRODUCT_RESEARCH template to validate my idea"
"Run a security audit using SECURITY_AUDIT_TEMPLATE"
```

### Copy to a project:
```bash
cp templates/PRODUCT_RESEARCH.md /path/to/project/
```

---

## Adding New Resources

**Agents:** Save to `agents/[NAME]_AGENT.md`

**Scripts:** Save to `scripts/[NAME].sh`

**Templates:** Save to `templates/[NAME].md` or `templates/[category]/[NAME].md`

Update this file when adding new resources.
