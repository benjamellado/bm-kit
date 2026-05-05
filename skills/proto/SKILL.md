---
name: proto
description: Run a pre-alignment prototype loop — grill the developer about what a feature does (not how to build it), generate a self-contained HTML prototype, then assess readiness and offer to iterate or wrap. Use when user wants to prototype a feature, validate an idea visually, says "proto", "prototype", or wants stakeholder-ready mockups before writing code.
---

Read `${CLAUDE_PLUGIN_ROOT}/context/workflow.md` for workflow context.

## Session opening

Before asking the first question:

1. If `CONTEXT.md` exists in the project root, read it to seed domain language and actor vocabulary.
2. Ask the user for a **feature slug** (kebab-case, e.g. `invoice-export`) if not already provided.
3. Check `.scratch/<feature-slug>/prototype/`:
   - If `brief.md` exists, read it. Find the latest versioned HTML (`001-*.html`, `002-*.html`…) and read it too. Open with: "I've loaded the brief and latest prototype — picking up from spiral N. What changed since last time?"
   - Otherwise: create `.scratch/<feature-slug>/prototype/` and start fresh.

---

## Grilling phase

Scope: **what** the feature does — not how to build it.

Ask about:
- Who uses it (actor / user role)
- What core action they take
- What data/inputs are involved
- What outputs or results need to be visible
- Any edge cases or secondary states worth showing

Do NOT ask about: implementation, architecture, stack choices, APIs, data models, or performance.

Ask **one question at a time**. No fixed limit — grill until you have:
- A clear user/actor
- A core action
- The key data fields / visible outputs

When you have enough, announce: **"I have enough — generating prototype now."**

---

## Prototype generation

- Single self-contained HTML file — inline CSS and JS, CDN dependencies allowed
- Functional clarity over visual polish: show what the feature does, not how it looks
- Even backend features get an HTML view (table, summary card, filter panel, confirmation screen)
- Determine the next version number by listing `.scratch/<feature-slug>/prototype/` for existing `NNN-*.html` files; increment the highest, pad to three digits
- Write to `.scratch/<feature-slug>/prototype/<NNN>-<feature-slug>.html`

---

## brief.md — living document

After generating the prototype, write/update `.scratch/<feature-slug>/prototype/brief.md`:

```
## What it is
<one paragraph, updated each spiral>

## Who uses it
<actor(s)>

## Core functionality
- <bullet list, updated each spiral>

## Validated
- <decisions confirmed across spirals>

## Open questions
- <accumulated stakeholder questions — new items appended, never removed>

## Spiral log
- Spiral N — <what changed, version generated>
```

Rules:
- **What it is**, **Who uses it**, **Core functionality**: replace with updated content each spiral
- **Validated**: append new confirmed decisions, never remove
- **Open questions**: append only — never remove items
- **Spiral log**: append one entry per spiral

---

## Exit behaviour

After each spiral, ask:

> "This looks ready to show stakeholders. Want to wrap here, keep iterating, or stop for now?"

- **Wrap**: run `/bm-kit:to-prd` or hand off `brief.md` + latest HTML to `/bm-kit:grill-me`
- **Keep iterating**: start next spiral — re-grill on what changed, generate next version
- **Stop for now**: files are already written — no explicit save needed

Files are written incrementally. No data loss if the user stops mid-session.

---

## Pipeline integration

- `brief.md` + latest HTML are the handoff artefacts into `/bm-kit:grill-me`
- This skill does NOT write `PRD.md` — that is `/bm-kit:to-prd`'s job
- Works standalone in repos with no prior bm-kit setup
