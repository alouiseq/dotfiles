# Claude Code Templates

Reusable templates for common tasks across projects.

## Available Templates

| Template | Description | Usage |
|----------|-------------|-------|
| `SECURITY_AUDIT_TEMPLATE.md` | Security audit checklist for web apps | Copy to project, ask Claude to run audit |

## How to Use

### Copy to a new project:
```bash
cp ~/.claude/templates/SECURITY_AUDIT_TEMPLATE.md /path/to/project/SECURITY_AUDIT.md
```

### Or reference directly:
Ask Claude: "Run a security audit using ~/.claude/templates/SECURITY_AUDIT_TEMPLATE.md"

## Adding New Templates

Save new templates to `~/.claude/templates/` for reuse across projects.

Suggested naming:
- `[PURPOSE]_TEMPLATE.md` for documentation templates
- `[PURPOSE]_CHECKLIST.md` for checklists
- `[PURPOSE]_AGENT.md` for specialized agent prompts
