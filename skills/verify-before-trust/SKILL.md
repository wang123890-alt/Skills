---
name: verify-before-trust
description: >-
  Use this whenever you need to review or merge work completed by another AI
  collaborator/agent before accepting it, or whenever you're investigating why
  something isn't working and about to settle on an explanation. Make sure to
  use this skill whenever a task involves trusting another agent's report of
  what they did (their commit message, their claim that tests pass, their
  claim that an API doesn't support something), deciding whether to
  merge/accept someone else's completed work, or diagnosing a recurring
  problem — even if the user doesn't explicitly ask for a "review" or
  "verification." Two triggers in particular. First, about to merge, accept,
  or build on top of work another agent, session, or collaborator says is
  done. Second, about to conclude that the reason for a technical problem is
  X, especially if X sounds plausible but hasn't been independently checked.
---

# Verify Before Trust

Two related habits that prevent the most common and costly failure mode in multi-agent
collaboration: accepting a plausible-sounding claim instead of checking it directly.
Both come from the same root cause — settling for the first answer that "sounds right"
rather than getting primary evidence.

## When to use which half

- **Part 1 (Review Before Merge)** — someone (another agent, a teammate, a prior session)
  says a piece of work is done and you're about to accept/merge/build on it.
- **Part 2 (Exhaust Real Options)** — you're diagnosing why something is broken, evaluating
  whether a constraint is real, or about to write down "the reason is X."

Often both apply in sequence: you review a fix (Part 1), find it's a band-aid, then have
to dig for the real cause (Part 2).

---

## Part 1: Review Before Merge

Never accept "done" at face value — including your own earlier conclusions from a prior
session. A report of completion is a claim, not evidence. Get the evidence yourself.

**The checklist, in order:**

1. **Get the actual artifact**, not the description of it. Clone the repo / open the file /
   pull the actual diff — don't review a summary of what changed.
2. **Re-run what they claim to have run.** "Tests pass" → run the tests yourself. "Lint is
   clean" → run the linter yourself. "Verified with X" → do X yourself if you can. A claim
   that a check passed is not the same as the check having passed in front of you.
3. **Boot the real thing if the change is structural.** Code that reads correctly can still
   fail at runtime — e.g. two modules importing under the same name and silently
   overwriting each other, config that's syntactically valid but never gets loaded, a
   route that's defined but never registered. Reading the diff misses this. Actually
   starting the app / hitting the real endpoint / loading the real config catches it.
4. **If the collaborator had reduced ability to verify** (sandboxed, no network, no access
   to the real environment), that reduces how much their "looks done" is worth — do a
   fuller check yourself precisely because they couldn't.
5. **Cross-check any "not possible because X" claim before accepting it as a boundary.**
   Especially convenient-sounding constraints ("that API doesn't support this," "that's
   always going to be slow," "we have to accept this limitation") — verify X directly
   before designing around it. See Part 2.
6. **Only write down what you personally verified**, not what was claimed. When recording
   the outcome, distinguish "I confirmed X" from "they said X."

**If two collaborators did overlapping work independently** (common when one was
temporarily unavailable and someone else stepped in), don't just take the one that
merged first — check whether the other one found something the first one missed. Merge
conflicts here are a feature, not just friction: they're where you catch that a
faster/simpler explanation was actually available.

---

## Part 2: Exhaust Real Options Before Settling

The first explanation that sounds plausible is usually *an* explanation, not necessarily
*the* explanation. This matters most when:

- **The symptom keeps recurring** despite a fix — a real root cause, once actually fixed,
  stops recurring. If it comes back, the fix addressed a symptom, not the cause.
- **The fix feels like a band-aid** ("we'll just retry," "we'll just check twice," "we'll
  just wait longer") — band-aids are sometimes the right call under real constraints, but
  say so explicitly rather than presenting a workaround as a root-cause fix.
- **Someone pushes back on your explanation.** Treat that as a signal to re-open the
  investigation, not just to defend the existing answer more firmly. If the pushback is
  "that constraint doesn't sound right, how do other people avoid it" — that's usually
  correct, because most "impossible" claims about a public system have a working
  counter-example somewhere (another site doing the exact thing you said you couldn't do).

**How to actually do this, concretely:**

1. **List every candidate cause/source you can think of, not just the first one and its
   opposite.** Two options ("current approach" vs "the one alternative I thought of") is
   usually not exhaustive. If there are three plausible data sources, check all three, not
   the two that occurred to you first.
2. **Get primary evidence for each candidate, at the same moment if timing matters.** Don't
   compare "what candidate A did yesterday" to "what candidate B does today" — fetch/query
   them side by side, right now, so the comparison is real.
3. **Use direct tool access over secondhand summaries.** A blog post from 2019 saying "you
   need a cookie for this API" is a data point, not the answer — actually try the call
   without one. A community claim that "X is blocked" — actually attempt X and read the
   real error.
4. **Don't stop at the first source that confirms your hypothesis.** If you expected the
   answer to be "rate limiting" and you found one page mentioning rate limits, that's not
   confirmation — check whether the timing/pattern of the actual failure matches rate
   limiting specifically, or whether it's equally consistent with something else.
5. **When you do settle on an explanation, say what you *didn't* check** so the next person
   (or your future self) knows where the remaining uncertainty is, instead of presenting a
   partial investigation as a closed case.

---

## What this looks like in practice

A representative example of both parts firing in sequence:

- A recurring "stale data" bug gets fixed by scheduling a retry (Part 1's checklist would
  have flagged: does the fix address the cause, or work around it? — it was a workaround).
- Someone asks "why would the official data source ever be delayed — how do other apps
  show live data?" (this is exactly the Part 2 trigger: a claimed constraint gets
  challenged).
- Investigating properly (not settling for "official data is sometimes just delayed")
  turns up that there were actually *two different official endpoints* for the same data,
  and the one in use happened to be slower — not because delay is inherent, but because of
  which specific endpoint was chosen.
- The real fix was a two-line change (switch endpoints), not the earlier multi-step
  workaround.

The lesson generalizes: **"it's just how the system works" is a hypothesis to test, not a
starting assumption** — and the way to test it is to go get the primary evidence yourself,
not to reason further from what you already believe.
