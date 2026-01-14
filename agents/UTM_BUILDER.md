# UTM Link Builder

When asked to generate UTM links, create trackable marketing URLs.

**Base URL:** `https://YOUR_DOMAIN.com`

## Parameters

| Parameter | Required | Description | Examples |
|-----------|----------|-------------|----------|
| utm_source | Yes | Traffic source | reddit, twitter, x, facebook, google, newsletter, producthunt, discord |
| utm_medium | Yes | Marketing medium | social, cpc, email, referral |
| utm_campaign | Yes | Campaign name | beta, launch, promo_2025 |
| utm_content | No | Differentiates links | r_fitness, post1, banner_ad |
| utm_term | No | Paid search keywords | fitness+tracker |

## Examples

User: "generate utm link for reddit"
```
https://YOUR_DOMAIN.com?utm_source=reddit&utm_medium=social&utm_campaign=beta
```

User: "utm for twitter"
```
https://YOUR_DOMAIN.com?utm_source=twitter&utm_medium=social&utm_campaign=beta
```

User: "utm link for r/fitness subreddit"
```
https://YOUR_DOMAIN.com?utm_source=reddit&utm_medium=social&utm_campaign=beta&utm_content=r_fitness
```

User: "generate links for all social channels"
```
https://YOUR_DOMAIN.com?utm_source=reddit&utm_medium=social&utm_campaign=beta
https://YOUR_DOMAIN.com?utm_source=twitter&utm_medium=social&utm_campaign=beta
https://YOUR_DOMAIN.com?utm_source=x&utm_medium=social&utm_campaign=beta
https://YOUR_DOMAIN.com?utm_source=facebook&utm_medium=social&utm_campaign=beta
https://YOUR_DOMAIN.com?utm_source=instagram&utm_medium=social&utm_campaign=beta
https://YOUR_DOMAIN.com?utm_source=discord&utm_medium=social&utm_campaign=beta
https://YOUR_DOMAIN.com?utm_source=producthunt&utm_medium=referral&utm_campaign=beta
```

User: "paid ad links"
```
https://YOUR_DOMAIN.com?utm_source=facebook&utm_medium=cpc&utm_campaign=ads
https://YOUR_DOMAIN.com?utm_source=google&utm_medium=cpc&utm_campaign=ads
```

## Output Format

Just output the link(s), ready to copy. No extra explanation needed.

---

## Setup Instructions

1. Copy to your project: `cp ~/.claude/agents/UTM_BUILDER.md your-project/docs/`
2. Replace `YOUR_DOMAIN.com` with your actual domain
3. Update campaign names as needed
4. Reference from CLAUDE.md:
   ```markdown
   ## Agent Instructions
   - **[UTM Link Builder](docs/UTM_BUILDER.md)** - Generate trackable marketing URLs
   ```
