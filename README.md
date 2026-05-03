# bm-kit

bm-kit is a personal Claude Code plugin that unifies the full AI-assisted development workflow — from raw idea to shipped code — into a single installable toolkit. Every skill reads and writes the same local `.scratch/` directory, so there is no translation between planning and implementation.

## Install

```bash
claude plugin install github.com/benjamellado/bm-kit --scope user
```

## Per-project setup

In any project directory:

```
/bm-kit:init
```

This creates `.scratch/`, `CONTEXT.md`, and `docs/adr/` in the current project.

## Workflow

```
init → grill-me → grill-with-docs → to-prd → to-issues → triage → ralph
```

| Skill | Command | What it does |
|-------|---------|--------------|
| Init | `/bm-kit:init` | Bootstrap a project with `.scratch/`, `CONTEXT.md`, `docs/adr/` |
| Grill me | `/bm-kit:grill-me` | Stress-test a feature idea through relentless questioning |
| Grill with docs | `/bm-kit:grill-with-docs` | Lock down terminology, update `CONTEXT.md` and ADRs |
| To PRD | `/bm-kit:to-prd` | Synthesize the conversation into a PRD at `.scratch/<feature>/PRD.md` |
| To issues | `/bm-kit:to-issues` | Break a PRD into vertically-sliced issues at `.scratch/<feature>/issues/` |
| Triage | `/bm-kit:triage` | Set issue status: `ready-for-agent`, `needs-info`, `wontfix`, etc. |
| Ralph | `/bm-kit:ralph <feature>` | Run the implementation loop — pick, implement, commit, repeat |

### Utility skills

| Skill | Command | What it does |
|-------|---------|--------------|
| Improve architecture | `/bm-kit:improve-codebase-architecture` | Find refactoring opportunities between features |
| Diagnose | `/bm-kit:diagnose` | Disciplined debugging: reproduce → minimise → fix → regression test |
| TDD | `/bm-kit:tdd` | Build features test-first with red-green-refactor |
| Write a skill | `/bm-kit:write-a-skill` | Extend the bm-kit toolkit with new skills |
| Caveman | `/bm-kit:caveman` | Compressed output mode — ~75% fewer tokens |

## `.scratch/` structure

```
.scratch/
  <feature-slug>/
    PRD.md                   # Feature spec (written by /bm-kit:to-prd)
    progress.txt             # Feature-scoped implementation learnings
    issues/
      01-<slug>.md           # Issues in dependency order
      02-<slug>.md
      ...
progress.txt                 # Global codebase patterns (project root)
```

### Issue status lifecycle

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

## Credits

bm-kit is built on the work of:

- **[Ralph](https://github.com/snarktank/ralph)** by snarktank — the original autonomous agent loop pattern
- **[Matt Pocock Skills](https://github.com/mattpocock/skills)** — the skill architecture and several core skill prompts
