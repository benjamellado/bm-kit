---
name: backlog
description: Manage Backlog items in .scratch/backlog/. With a text argument, quick-parks a new item. With no argument mid-conversation, synthesizes a contextual item from the thread. With no argument in a fresh session, lists open items. Use when user wants to capture an idea, park a tangent, defer something, or see what's deferred.
allowed-tools: Bash, Read, Write, Glob
---

Manage the Backlog at `.scratch/backlog/`. Three behaviors depending on invocation:

---

## Trigger conditions

| Invocation | Context | Behavior |
|---|---|---|
| With a text argument | any | Quick-park |
| No argument | conversation thread present | Contextual park |
| No argument | fresh session / no prior thread | List |

**How to detect conversation context:** if the conversation contains prior messages beyond the skill invocation itself (i.e., there is a thread of discussion to synthesize from), use contextual park. If this is the opening message of the session with no prior discussion, use list.

---

## With a text argument — quick-park

The argument is the title of a new Backlog item.

1. Create `.scratch/backlog/` if it does not exist: `mkdir -p .scratch/backlog`
2. Scan `.scratch/backlog/` for existing `NN-*.md` files. Extract the numeric prefix from each filename. The next sequence number is one higher than the current maximum, zero-padded to two digits (e.g. `01`, `02`, `03`). If no files exist, start at `01`.
3. Generate a slug: lowercase the title, replace spaces and special characters with hyphens, strip leading/trailing hyphens. Keep it short (3–5 words max).
4. Write `.scratch/backlog/NN-slug.md` with this exact frontmatter and no body:

```markdown
---
id: BL-NN
title: <title as provided>
status: open
created: <today's date, ISO format YYYY-MM-DD>
---
```

5. Confirm the created path to the user:

> Parked: `.scratch/backlog/NN-slug.md`

---

## No argument, conversation context present — contextual park

Synthesize an enriched Backlog item from the current conversation thread.

1. Read the conversation thread. Synthesize:
   - A short, descriptive **title** (5–8 words) that captures the core topic.
   - An enriched **body** covering:
     - **Summary** — what was discussed (2–4 sentences)
     - **Key decisions** — any decisions or conclusions reached
     - **Open questions** — unresolved questions a future session should pick up
     - **Relevant context** — any background, constraints, or links a future session needs to resume

2. Present the proposed title to the user and wait for confirmation:

   > Park this as: "[synthesized title]"?

3. **On confirmation:**
   - Create `.scratch/backlog/` if it does not exist: `mkdir -p .scratch/backlog`
   - Scan `.scratch/backlog/` for existing `NN-*.md` files. The next sequence number is one higher than the current maximum, zero-padded to two digits. If no files exist, start at `01`.
   - Generate a slug from the title: lowercase, hyphens, 3–5 words max.
   - Write `.scratch/backlog/NN-slug.md` with full frontmatter and the enriched body:

```markdown
---
id: BL-NN
title: <synthesized title>
status: open
created: <today's date, ISO format YYYY-MM-DD>
---

## Summary

<what was discussed>

## Key decisions

- <decision 1>
- <decision 2>

## Open questions

- <question 1>
- <question 2>

## Context

<relevant background, constraints, or links>
```

   - Report the created path to the user:

     > Parked: `.scratch/backlog/NN-slug.md`

4. **On decline:** discard without writing anything.

---

## No argument, fresh session — list

Read all `.scratch/backlog/*.md` files. For each file, parse the frontmatter. Collect items where `status: open`. Skip items with `status: picked-up` or `status: done`.

If open items exist, print a compact table:

```
# Backlog (N open)

NN  Title                          Created
──  ─────────────────────────────  ──────────
01  Example idea                   2026-05-01
02  Another deferred thought       2026-05-03
```

If `.scratch/backlog/` does not exist or contains no open items, print:

> Backlog is empty. Run `/bm-kit:backlog <title>` to park an idea.
