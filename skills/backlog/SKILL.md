---
name: backlog
description: Quick-park and list Backlog items in .scratch/backlog/. With a text argument, creates a new open Backlog item. With no argument, lists all open items. Use when user wants to capture an idea, park a tangent, or see what's deferred.
allowed-tools: Bash, Read, Write, Glob
---

Manage the Backlog at `.scratch/backlog/`. Two behaviors depending on invocation:

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

## No argument — list

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
