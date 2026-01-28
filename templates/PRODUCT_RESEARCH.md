# Product Research & Validation

A framework for researching, validating, and finding product-market fit before and during building. Use this to avoid building things nobody wants.

---

## The Core Principle

**Build things people want, not things you hope people want.**

The goal isn't to validate your idea. It's to find the truth - even if the truth is "nobody cares."

---

## Phase 1: Problem Discovery

Before you have a solution, find a problem worth solving.

### Where to Find Problems

| Source | What to Look For | How to Search |
|--------|------------------|---------------|
| Reddit | Complaints, frustrations, "I wish..." posts | `reddit.com/r/[niche] "frustrated" OR "hate" OR "wish"` |
| Twitter/X | Rants, complaints, "why is there no..." | Search pain point keywords |
| Product Hunt | Negative comments on competitors | Read comment sections |
| App Store Reviews | 1-3 star reviews on competitors | Filter by "Most Critical" |
| Indie Hackers | Founders sharing what users complain about | Search your niche |
| Quora | Questions with high engagement | Browse your topic area |
| Customer Support Forums | Unresolved issues, feature requests | Company forums, Discord servers |

### Problem Qualification Checklist

Before committing to a problem, answer these:

- [ ] Are people actively looking for solutions? (search volume, Reddit posts)
- [ ] Are people already paying for imperfect solutions? (existing competitors with revenue)
- [ ] Is the problem frequent or painful enough to pay to solve?
- [ ] Can you reach these people? (do you know where they hang out?)
- [ ] Are you interested enough to work on this for 1-2 years?

### Red Flags (Problems to Avoid)

- "Nice to have" problems (vitamins vs painkillers)
- Problems only you have (sample size of 1)
- Problems with no existing solutions AND no search volume (maybe not a real problem)
- Problems that require changing human behavior significantly
- Problems where the audience can't/won't pay

---

## Phase 2: Solution Validation

You have a problem. Now validate that YOUR solution is wanted.

### The Mom Test

When talking to potential users, ask questions that can't be answered with polite lies.

**Bad questions (lead to false validation):**
- "Would you use an app that does X?" (Yes = polite, not commitment)
- "Do you think this is a good idea?" (People don't want to hurt your feelings)
- "Would you pay for this?" (Hypothetical = meaningless)

**Good questions (reveal truth):**
- "How are you solving this problem today?" (Shows if they care enough to act)
- "What have you tried that didn't work?" (Shows pain level)
- "When did you last experience this problem?" (Recent = real, vague = not urgent)
- "What did you do about it?" (Action = real pain)
- "How much time/money are you spending on this now?" (Quantifies the problem)

### Validation Signals

| Signal | Strength | What It Means |
|--------|----------|---------------|
| "Sounds cool" | Weak ❌ | Polite, not interested |
| "Let me know when it's ready" | Weak ❌ | No commitment |
| Email signup | Medium | Some interest |
| Asks detailed questions | Medium-Strong | Genuinely curious |
| Describes their exact use case | Strong ✅ | Has the problem |
| Offers to pay / pre-order | Very Strong ✅ | Real demand |
| Sends you money | Strongest ✅✅ | Validated |

### Pre-Selling (Strongest Validation)

Before building, try to sell:

1. **Landing page + payment** - "Pay $X now, get lifetime access when it launches"
2. **DM conversations** - "I'm building X. Would you pay $Y for it?"
3. **Fake door test** - Button for feature that doesn't exist, measure clicks
4. **Concierge MVP** - Deliver the value manually before automating

If people won't pay before it exists, they probably won't pay after either.

---

## Phase 3: Pain Point Research

Deep dive into what users actually need.

### Interview Framework

**Setup:**
- Talk to 10-20 potential users minimum
- Record calls (with permission) for exact language
- Take notes on emotions, not just words

**Questions to ask:**

1. "Tell me about the last time you [did the thing your product helps with]"
2. "What was the hardest part?"
3. "Why was that hard?"
4. "What did you do about it?"
5. "What have you tried before?"
6. "What don't you like about [current solution]?"
7. "If you could wave a magic wand, what would be different?"
8. "How much time/money does this cost you now?"

**What to capture:**
- Exact words they use (for marketing copy later)
- Emotional intensity (frustration, anger, resignation)
- Workarounds they've built (shows pain level)
- What they've tried and abandoned (competitive intel)

### Reddit/Community Research

When lurking for pain points:

```
Search queries:
"[niche] frustrated"
"[niche] hate"
"[niche] switched from"
"[niche] looking for"
"[niche] recommend"
"[niche] vs"
"why is [category] so"
```

**What to capture:**
- The exact problem statement
- How they describe the pain
- What solutions they've tried
- What's missing from current solutions
- Link to thread (for revisiting later)

### Pain Point Documentation Template

```markdown
## Pain Point: [Name]

**Source:** [Reddit thread / Interview / Review]
**Frequency:** [How often mentioned]
**Intensity:** [Low / Medium / High / Hair-on-fire]

**User's exact words:**
> "[Quote]"

**Current solutions they've tried:**
- [Solution 1] - Why it failed: [reason]
- [Solution 2] - Why it failed: [reason]

**What they wish existed:**
> "[Quote]"

**Would they pay?** [Evidence]

**Relevance to our product:** [How we could solve this]
```

---

## Phase 4: Competitor Analysis

Understand the landscape before entering.

### Competitor Research Template

For each competitor:

```markdown
## [Competitor Name]

**URL:**
**Pricing:**
**Target audience:**

**What they do well:**
-
-

**What users complain about:** (from reviews, Reddit, Twitter)
-
-

**Gaps / What's missing:**
-
-

**Why users switch away:**
-

**Why users stay:**
-
```

### Where to Find Competitor Intel

| Source | What You'll Learn |
|--------|-------------------|
| App Store reviews (1-3 stars) | What's broken, what's missing |
| Reddit "[competitor] vs" threads | Why people switch |
| Twitter complaints | Real-time frustrations |
| G2/Capterra reviews | Business user perspectives |
| Their changelog | What they're prioritizing |
| Their job postings | Where they're investing |

### Competitive Positioning

After research, answer:

1. What do competitors do that users love? (don't compete here)
2. What do competitors do poorly? (opportunity)
3. What do competitors NOT do? (potential gap)
4. Why would someone choose you over them? (positioning)

---

## Phase 5: Product-Market Fit Indicators

How to know if you're getting there.

### Weak PMF Signals

- People say they like it
- Signups are growing (but not usage)
- Press/media coverage
- Investor interest

### Strong PMF Signals

- Users come back without prompting (retention)
- Users recommend to others (organic growth)
- Users complain when it's down (dependency)
- Users pay AND continue paying (revenue retention)
- "I'd be very disappointed if this went away" - 40%+ of users

### The Sean Ellis Test

Ask users: "How would you feel if you could no longer use [product]?"

- Very disappointed
- Somewhat disappointed
- Not disappointed

**PMF indicator:** 40%+ say "very disappointed"

### Metrics That Matter

| Metric | What It Tells You |
|--------|-------------------|
| Retention (Day 7, Day 30) | Are people coming back? |
| NPS / Sean Ellis score | Would they recommend / miss it? |
| Revenue churn | Are paying users staying? |
| Organic signups | Are users telling others? |
| Time to value | How fast do users get benefit? |

---

## Phase 6: Kill Criteria

When to walk away.

### Time Limits

- **Validation phase:** 2-4 weeks max. If you can't find 10 people who care, move on.
- **Building + initial traction:** 6-12 months max. If no PMF signals, reassess.
- **Overall:** 1 year max on an idea with no traction (per the Reddit advice)

### Kill Signals

- Can't find people who have this problem
- People have the problem but won't pay
- Users try it once and never return
- Growth only happens when you're pushing (no organic)
- You've pivoted 3+ times with no improvement
- You're not excited to work on it anymore

### Pivot vs Kill

**Pivot if:**
- Users love part of it (double down on that)
- Adjacent problem is more painful
- Same users, different solution

**Kill if:**
- No engagement despite multiple attempts
- Market is shrinking or non-existent
- You've lost conviction
- Opportunity cost is too high

---

## Learnings Log

*Add findings from research here. Date each entry.*

### Template

```markdown
### [Date] - [Source/Context]

**Finding:**
[What you learned]

**Evidence:**
[Quotes, data, links]

**Implication:**
[What this means for product decisions]

**Action:**
[What to do with this information]
```

### Entries

*(Add your research findings below)*

---

## Research Checklist (Before Building)

- [ ] Identified a specific problem (not just an idea)
- [ ] Found 10+ people who have this problem
- [ ] Talked to 5+ potential users (not friends/family)
- [ ] Documented pain points in their words
- [ ] Researched 3+ competitors
- [ ] Identified gap or differentiation
- [ ] Validated willingness to pay (not just interest)
- [ ] Know where to find more of these users
- [ ] Set kill criteria and timeline

---

## Quick Reference: Questions to Keep Asking

Throughout the journey:

1. "Is there evidence people will pay, or am I hoping?"
2. "Are users coming back without me pushing them?"
3. "What do users do, not what do they say?"
4. "Would I use this if I didn't build it?"
5. "Am I building what they want, or what I want to build?"
6. "What's the fastest way to learn if this works?"
7. "If this fails, will I know why?"

---

## Sources & Further Reading

- **The Mom Test** by Rob Fitzpatrick - How to talk to customers
- **Lean Startup** by Eric Ries - Build-measure-learn loop
- **Obviously Awesome** by April Dunford - Positioning
- **Deploy Empathy** by Michele Hansen - Customer research

---

*Living document. Update with learnings from each project.*
