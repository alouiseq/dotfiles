# Security Audit Guide

Use this guide to audit any codebase for security vulnerabilities. Copy this file to your project root and customize as needed.

## How to Run a Security Audit

Ask Claude: **"Run a security audit on this project"**

---

## Security Audit Checklist

### 1. Authentication & Authorization

**Check for:**
- [ ] Tokens properly validated (signature, expiration, issuer)
- [ ] Passwords hashed with strong algorithm (bcrypt, argon2, scrypt)
- [ ] No plaintext passwords in logs or error messages
- [ ] Protected routes require authentication
- [ ] Role-based access control enforced
- [ ] Session/token expiration is reasonable (not too long)
- [ ] Password reset flow is secure
- [ ] No hardcoded credentials or API keys

**Common files:**
- Auth middleware/services
- Login/register endpoints
- Token generation/validation

### 2. Input Validation & Injection

**Check for:**
- [ ] **SQL Injection**: Using parameterized queries or ORM
- [ ] **XSS**: User input sanitized/escaped before rendering
- [ ] **Command Injection**: No shell commands with user input
- [ ] **Path Traversal**: File paths validated, no `../` allowed
- [ ] **NoSQL Injection**: MongoDB queries sanitized
- [ ] All input validated (type, length, format)
- [ ] Request body size limits set
- [ ] File upload restrictions (type, size)

**Common files:**
- API endpoints
- Form handlers
- File upload handlers
- Database queries

### 3. Data Protection

**Check for:**
- [ ] HTTPS enforced in production
- [ ] Sensitive data encrypted at rest
- [ ] No sensitive data in URLs (use POST body)
- [ ] PII not logged or minimized
- [ ] Secure cookie flags (HttpOnly, Secure, SameSite)
- [ ] Database credentials not in code
- [ ] .env files in .gitignore
- [ ] No secrets in git history

**Common files:**
- Config files
- Database connections
- Cookie/session setup
- .gitignore

### 4. API Security

**Check for:**
- [ ] CORS configured properly (not `*` in production)
- [ ] Rate limiting on auth endpoints
- [ ] Rate limiting on expensive operations
- [ ] No sensitive data in error messages
- [ ] HTTP methods restricted (no unused methods)
- [ ] Debug mode disabled in production
- [ ] API versioning strategy
- [ ] Request/response logging (without secrets)

**Common files:**
- Main app/server config
- CORS middleware
- Error handlers

### 5. Dependency Security

**Check for:**
- [ ] No known vulnerabilities in dependencies
- [ ] Dependencies pinned to specific versions
- [ ] Lock file committed (package-lock.json, poetry.lock)
- [ ] No unnecessary dependencies
- [ ] Regular dependency updates

**Commands:**
```bash
# Python
pip-audit
# or: safety check -r requirements.txt

# Node.js
npm audit
# or: yarn audit

# General
snyk test
```

### 6. Secrets Management

**Check for:**
- [ ] No secrets in code
- [ ] No secrets in git history
- [ ] Environment variables for all secrets
- [ ] Different secrets for dev/staging/prod
- [ ] Secrets have appropriate rotation policy
- [ ] .env.example has no real values

**Commands:**
```bash
# Search for potential hardcoded secrets
grep -rn "password\s*=" --include="*.py" --include="*.js" --include="*.ts" .
grep -rn "api_key\s*=" --include="*.py" --include="*.js" --include="*.ts" .
grep -rn "secret\s*=" --include="*.py" --include="*.js" --include="*.ts" .

# Check git history for secrets (use tools like truffleHog or git-secrets)
git log -p | grep -i "password\|secret\|api_key" | head -50
```

### 7. Error Handling & Logging

**Check for:**
- [ ] No stack traces exposed to users in production
- [ ] Generic error messages for auth failures (timing attacks)
- [ ] Errors logged server-side with context
- [ ] Failed login attempts logged
- [ ] Sensitive data redacted from logs
- [ ] Log injection prevented

### 8. Data Integrity & Loss Prevention

**Check for:**
- [ ] Database backups configured and tested
- [ ] Soft deletes where appropriate
- [ ] Cascade deletes reviewed for data loss
- [ ] Transaction rollback on errors
- [ ] Idempotent operations where needed
- [ ] Audit trail for sensitive operations

### 9. Infrastructure (if applicable)

**Check for:**
- [ ] Firewall rules restrict unnecessary access
- [ ] Database not publicly accessible
- [ ] SSH key-based auth (no passwords)
- [ ] Least privilege for service accounts
- [ ] Secrets in secure storage (not env vars on disk)
- [ ] TLS 1.2+ enforced

### 10. Frontend-Specific (Web Apps)

**Check for:**
- [ ] CSP (Content Security Policy) headers
- [ ] X-Frame-Options / frame-ancestors
- [ ] X-Content-Type-Options: nosniff
- [ ] Referrer-Policy configured
- [ ] No sensitive data in localStorage (prefer httpOnly cookies)
- [ ] Subresource Integrity for CDN scripts
- [ ] Form autocomplete disabled for sensitive fields

---

## Severity Levels

| Level | Description | Examples |
|-------|-------------|----------|
| **CRITICAL** | Immediate exploitation risk | SQL injection, auth bypass, RCE |
| **HIGH** | Significant security impact | Sensitive data exposure, weak crypto, broken access control |
| **MEDIUM** | Moderate risk | CORS misconfiguration, missing rate limits, info disclosure |
| **LOW** | Minor issues | Best practice violations, verbose errors in dev |

---

## Report Template

```markdown
## Security Audit Report - [Project Name]
**Date:** YYYY-MM-DD
**Auditor:** Claude Code

### Summary
- Critical: X
- High: X
- Medium: X
- Low: X

### Findings

#### [SEVERITY] Finding Title
**Location:** `path/to/file.py:123`
**Description:** What the issue is
**Risk:** What could happen if exploited
**Recommendation:** How to fix it
**Code:**
\`\`\`python
# Vulnerable code
\`\`\`
```

---

## Post-Audit Actions

1. [ ] Create issues/tickets for each finding
2. [ ] Fix CRITICAL issues immediately
3. [ ] Fix HIGH issues before release
4. [ ] Schedule MEDIUM/LOW for future sprints
5. [ ] Re-audit after fixes
6. [ ] Document security decisions

---

## Usage

Copy to your project:
```bash
cp ~/.claude/templates/SECURITY_AUDIT_TEMPLATE.md ./SECURITY_AUDIT.md
```

Then ask Claude: "Run a security audit following SECURITY_AUDIT.md"
