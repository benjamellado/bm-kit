# Issue tracker: Local Markdown

Issues and PRDs for this repo live as markdown files in `.scratch/`.

## Directory structure

```
.scratch/
  <feature-slug>/
    PRD.md                   # Feature spec (written by /bm-kit:to-prd)
    progress.txt             # Feature-scoped learnings (written by ralph loop)
    issues/
      01-<slug>.md           # First issue (lowest number = first to implement)
      02-<slug>.md
      ...
progress.txt                 # Global cross-cutting codebase patterns (project root)
```

## Issue frontmatter

Every issue file must begin with YAML frontmatter:

```yaml
---
id: <FEATURE-NN>          # e.g. BM-01, AUTH-03
title: <short title>
status: <status>          # see valid values below
priority: <number>        # 1 = highest
---
```

### Valid status values

| Status | Meaning |
|--------|---------|
| `needs-triage` | Newly created, not yet reviewed |
| `needs-info` | Blocked waiting for more information |
| `ready-for-agent` | Scoped and safe for autonomous implementation |
| `ready-for-human` | Requires human judgment or access |
| `wontfix` | Decided not to implement |
| `done` | Implementation complete and committed |

## Filename convention

Issues are named `NN-slug.md` where `NN` is a zero-padded two-digit number starting at `01`. The number encodes dependency order — the ralph loop processes files in ascending filename order, so `01-` is always implemented before `02-`.

## PRD frontmatter

PRD files use a minimal frontmatter:

```yaml
---
status: needs-triage
type: prd
---
```

## Comments section

Conversation history, triage decisions, and agent briefs are appended under a `## Comments` heading at the bottom of the file.

## When a skill says "publish to the issue tracker"

Create a new file under `.scratch/<feature-slug>/` (creating the directory if needed).

## When a skill says "fetch the relevant ticket"

Read the file at the referenced path. The user will normally pass the path or the issue number directly.
