# bm-kit Workflow

bm-kit is a Claude Code plugin that unifies the full AI-assisted development workflow — from raw idea to shipped code — using a single local source of truth: `.scratch/` markdown files.

## Pipeline

```
install → init → grill-me → grill-with-docs → to-prd → to-issues → triage → ralph
```

Each step hands off to the next. No translation between formats — every skill reads and writes `.scratch/`.

---

## Skills

### `/bm-kit:init`

**Purpose:** Bootstrap a new project for bm-kit use.

**Creates:** `.scratch/`, `CONTEXT.md`, `docs/adr/` in the current project directory.

**Next step:** Run `/bm-kit:grill-me` to explore a feature idea.

---

### `/bm-kit:grill-me`

**Purpose:** Stress-test a feature idea through relentless questioning. Surfaces assumptions, constraints, and design decisions before any code is written.

**Produces:** A shared understanding of the feature and a clear list of open questions resolved.

**Next step:** Run `/bm-kit:grill-with-docs` to lock down domain terminology.

---

### `/bm-kit:grill-with-docs`

**Purpose:** Challenge the plan against the existing domain model. Sharpens terminology and updates `CONTEXT.md` inline as decisions crystallise.

**Produces:** Updated `CONTEXT.md` and any new ADRs in `docs/adr/`.

**Next step:** Run `/bm-kit:to-prd` to synthesize the conversation into a PRD.

---

### `/bm-kit:to-prd`

**Purpose:** Synthesize the grilling conversation into a structured PRD.

**Produces:** `.scratch/<feature-slug>/PRD.md` with `status: needs-triage` frontmatter.

**Next step:** Run `/bm-kit:to-issues` to break the PRD into implementable issues.

---

### `/bm-kit:to-issues`

**Purpose:** Break a PRD into vertically-sliced, independently-implementable issues.

**Produces:** `.scratch/<feature-slug>/issues/NN-slug.md` files, each with frontmatter (`id`, `title`, `status: needs-triage`, `priority`) and an agent brief.

**Next step:** Run `/bm-kit:triage` on each issue to set its status.

---

### `/bm-kit:triage`

**Purpose:** Review an issue and assign its status: `ready-for-agent`, `ready-for-human`, `needs-info`, or `wontfix`.

**Produces:** Updated `status` field in the issue's frontmatter.

**Next step:** Once all target issues are `ready-for-agent`, run `/bm-kit:ralph <feature-slug>`.

---

### `/bm-kit:ralph`

**Purpose:** Run the implementation loop for a feature. Invokes `ralph.sh` which picks the lowest-numbered `ready-for-agent` issue, runs Claude on it, marks it `done`, and repeats until all issues are complete.

**Produces:**
- Committed code for each implemented issue
- Updated `status: done` in each issue's frontmatter
- Appended learnings in `.scratch/<feature-slug>/progress.txt`
- Cross-cutting patterns appended to `progress.txt` at project root

**Stop condition:** `<promise>COMPLETE</promise>` in agent output, or no remaining `ready-for-agent` issues.

---

## Utility skills

These can be used at any point in the workflow:

| Skill | Purpose |
|-------|---------|
| `/bm-kit:improve-codebase-architecture` | Find refactoring opportunities between features |
| `/bm-kit:diagnose` | Systematic debugging loop for hard bugs |
| `/bm-kit:tdd` | Build features test-first |
| `/bm-kit:write-a-skill` | Extend the bm-kit toolkit with new skills |
| `/bm-kit:caveman` | Compress AI output to reduce token usage |

---

## `.scratch/` directory structure

```
.scratch/
  <feature-slug>/
    PRD.md                   # Feature spec
    progress.txt             # Feature-scoped implementation learnings
    issues/
      01-<slug>.md           # Issues in dependency order
      02-<slug>.md
      ...
progress.txt                 # Global codebase patterns (project root)
```

## Issue status lifecycle

```
needs-triage → needs-info ──┐
             ↓              │
      ready-for-agent ──────┤
      ready-for-human       │
             ↓              │
           done        wontfix
```

Valid status values: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`, `done`.

Filename ordering (`01-`, `02-`, ...) encodes dependency order. The ralph loop always picks the lowest-numbered `ready-for-agent` issue.
