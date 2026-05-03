# bm-kit

A Claude Code plugin that unifies the full AI-assisted development workflow — from raw idea to shipped code — using `.scratch/` markdown files as a single local source of truth.

## Language

**Skill**:
A named, installable capability invoked as `/bm-kit:<name>`. Reads and writes `.scratch/` and `CONTEXT.md`.
_Avoid_: command, plugin, tool

**Feature**:
A named unit of work with its own PRD, issues, and progress log under `.scratch/<feature-slug>/`.
_Avoid_: project, epic, story (story = issue)

**Issue**:
A single, self-contained unit of work inside a feature, stored as `.scratch/<feature-slug>/issues/NN-slug.md`.
_Avoid_: ticket, task, story

**Ralph loop**:
The autonomous implementation cycle: pick lowest-numbered `ready-for-agent` issue → implement → commit → mark done → repeat.
_Avoid_: agent loop, AI loop

**Understand**:
The skill that extracts and confirms codebase knowledge, populating `CONTEXT.md`. Opens by asking "anything specific to update?" — if yes, asks what and targets that; if no, walks through sections in order: empty first, then auto, then reviewed.
_Avoid_: deep-init, orient, scan, onboard

**Auto section**:
A section of `CONTEXT.md` tagged `<!-- auto -->`, written by the `understand` skill without human confirmation. Treated as potentially stale on re-run.
_Avoid_: generated section, draft section

**Reviewed section**:
A section of `CONTEXT.md` tagged `<!-- reviewed -->`, confirmed by a human. Left untouched by `understand` on re-run.
_Avoid_: confirmed section, locked section

**CONTEXT.md sections**:
The named chunks of knowledge that `understand` reads, writes, and presents to the user. Canonical names: `Purpose`, `Stack`, `Run`, `Test`, `Architecture`, `Structure`, `Integrations`, `Workflow`, `Gotchas`. Domain language lives in `Language` (managed by `grill-with-docs`).
_Avoid_: chapter, panel, block

**Backlog**:
The pool of deferred ideas not yet in the active workflow. Lives at `.scratch/backlog/` as one file per item.
_Avoid_: todo list, future ideas, wishlist

**Backlog item**:
A single deferred idea stored as `.scratch/backlog/NN-slug.md`. Has frontmatter (`status`, `title`, `created`) and an optional enriched body.
_Avoid_: idea, entry, card, note

**Park**:
The action of saving an idea to the Backlog. Two modes: quick-park (one-liner via command) and contextual park (mid-session, auto-synthesizes enriched body from conversation context).
_Avoid_: save to backlog, defer, capture, add

**Backlog adjacency**:
The condition where the current session topic overlaps with an open Backlog item. When detected, the skill surfaces it inline: "this looks adjacent to X in your Backlog."
_Avoid_: overlap, match, similarity, conflict

**Backlog item status lifecycle**:
`open` → `picked-up` (item has entered the workflow, linked to `.scratch/<feature-slug>/`) → `done` (work complete).
_Avoid_: promoted, active, in-progress, started

## Relationships

- A **Feature** contains one or more **Issues**
- The **Ralph loop** processes **Issues** in filename order
- The **understand** skill writes **auto sections**; humans and `grill-with-docs` promote them to **reviewed sections**
- **CONTEXT.md sections** are walked in order: empty first → auto → reviewed
- A **Backlog item** is deferred until **picked-up**, at which point it seeds a **Feature**
- **Parking** creates a **Backlog item**; **Backlog adjacency** surfaces existing items during active sessions

## Flagged ambiguities

- "understand" is the skill name, not a description of what the agent does internally — it names the user's intent: "update my understanding of this codebase"
- "section" was confirmed over "panel", "chapter", "block" — standard markdown heading chunk
