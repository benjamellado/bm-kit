# bm-kit

bm-kit is a Claude Code plugin that connects the full arc of software development — from a half-formed idea to committed, tested code — through a single local source of truth: plain markdown files in `.scratch/`.

Most AI coding workflows break down not because the agent writes bad code, but because it keeps starting from zero. It doesn't know what your project is for, what words mean in your domain, what decisions you already made, or what you were thinking last time. Every session, you re-explain. Every session, you drift a little.

bm-kit fixes that by giving the agent a persistent, structured memory that grows with each session: `CONTEXT.md` for repo knowledge, `docs/adr/` for durable decisions, `.scratch/backlog/` for ideas not yet ready to build, and `.scratch/<feature>/` for everything from PRD to shipped issues. The agent reads this before it acts. You write to it as you think. Over time it becomes a second brain for the project.

## What a session looks like

You open Claude Code and run `/bm-kit:grill-me`. It checks your Backlog and says: "You have 2 open items — want to pick one up?" You pick the auth refactor you parked three days ago. It reads the notes you left — decisions made, open questions, relevant context — and picks up the conversation right where it ended.

You grill the idea for 20 minutes. Halfway through, a sub-problem surfaces that's interesting but out of scope. You say "park this" and the skill captures the full thread as a new Backlog item. You stay focused.

When the plan is solid you run `/bm-kit:to-prd`, then `/bm-kit:to-issues`. You get 5 vertically-sliced issues in dependency order. You triage them in two minutes. Then you run `/bm-kit:ralph auth-refactor` and go make coffee.

You come back to 4 commits, all passing, each one a clean vertical slice with a progress note. The fifth issue needed a human decision; it's marked `ready-for-human` and waiting. The implementation loop recorded two codebase patterns in `progress.txt` for the next agent session.

That's the rhythm: think carefully, decide explicitly, delegate confidently, come back to done work.

## Why each piece exists

**The Backlog** captures ideas in the moment — from a quick `/bm-kit:backlog "my idea"` to a mid-session "park this" that saves a full conversation summary. `grill-me` reads open Backlog items at the start of every session and surfaces overlap when the current topic touches something already deferred. Ideas stop getting lost.

**`CONTEXT.md` and `docs/adr/`** give the agent the context that lives only in your head: what the project does, how to run it, what terms mean, why surprising decisions were made. Written once, read every session. The agent stops asking questions you've already answered.

**Grilling before building** is where the real engineering happens. Talking through a change with an agent that pushes back — challenges assumptions, spots overloaded language, compares ideas against the actual architecture — is cheap. Finding the same problems after the code is written is not.

**PRDs and issues** make intent delegatable. A PRD preserves the "why." Issues turn it into dependency-ordered vertical slices, each with a clear outcome, so the agent can implement one verified piece at a time instead of guessing at a blob of intent.

**The Ralph loop** makes implementation repeatable and observable. It does not ask the agent to "go build the feature." It picks the lowest-numbered ready issue, implements it, runs checks, commits, records learnings, and loops. Each iteration is independently reviewable. Each commit is a clean unit. The repo gets better documented as it goes.

**Everything is local markdown.** No SaaS, no accounts, no sync. Git-native. You own it.

## Install

In Claude Code:

```
/plugin marketplace add benjamellado/bm-kit
/plugin install bm-kit@bm-kit
```

## Per-project setup

In any project directory:

```
/bm-kit:init
```

This creates `.scratch/`, `CONTEXT.md`, `docs/adr/`, and `progress.txt` in the current project.

## Workflows

bm-kit has two main workflows and a Backlog that connects them.

### Backlog

Ideas that surface at the wrong moment — during a session, mid-implementation, or just not ready yet — go into the Backlog. It's a holding area that feeds the feature workflow when you're ready.

```
/bm-kit:backlog "my idea"        # park a quick one-liner
/bm-kit:backlog                  # list open items (or park with context mid-session)
```

`grill-me` reads open Backlog items at the start of every session and offers to pick one up. It also detects when the current discussion overlaps with something already deferred and surfaces it inline.

### 1. Initiation workflow

Use this when bringing bm-kit into a repo, or when you want the agent to build a durable understanding of the codebase before starting feature work.

```
init → understand → grill-with-docs
```

- `/bm-kit:init` creates the local bm-kit structure.
- `/bm-kit:understand` extracts the repo's purpose, stack, run commands, tests, architecture, structure, integrations, and workflow into `CONTEXT.md`, then asks for the human context it cannot infer.
- `/bm-kit:grill-with-docs` challenges and refines that understanding with the human, sharpening domain language and writing durable decisions into `CONTEXT.md` and `docs/adr/`.

The output is a repo that the agent can navigate with context: terms are defined, architecture is summarized, commands are documented, and surprising decisions have a place to live.

### 2. Feature workflow

Use this once you are ready to work on a concrete change — whether it starts from a Backlog item or a fresh idea.

```
grill-me → to-prd → to-issues → triage → ralph → wrap
```

- `/bm-kit:grill-me` stress-tests the feature idea until the plan is clear. Opens by surfacing any open Backlog items so you can pick one up or start fresh.
- `/bm-kit:to-prd` turns the conversation into `.scratch/<feature>/PRD.md`.
- `/bm-kit:to-issues` breaks the PRD into thin, dependency-ordered implementation slices.
- `/bm-kit:triage` decides which issues are ready for the agent, need more information, need a human, or should not be done.
- `/bm-kit:ralph <feature>` runs the implementation loop: pick the next ready issue, implement it, test it, commit it, mark it done, and repeat.
- `/bm-kit:wrap <feature>` closes the loop — runs gap analysis against the PRD and issues, then opens a GitHub PR with a synthesized description.

`/bm-kit:grill-with-docs` can still be used during feature work when the discussion exposes new domain language or a durable architectural decision.

## Skills

### Backlog

| Skill | Command | What it does |
|-------|---------|--------------|
| Backlog | `/bm-kit:backlog <title>` | Quick-park a one-liner idea into `.scratch/backlog/` |
| Backlog | `/bm-kit:backlog` | List open items, or park the current session as an enriched item |

### Initiation skills

| Skill | Command | What it does |
|-------|---------|--------------|
| Init | `/bm-kit:init` | Bootstrap a project with `.scratch/`, `CONTEXT.md`, `docs/adr/`, and `progress.txt` |
| Understand | `/bm-kit:understand` | Pre-fill `CONTEXT.md` with a first-pass understanding of the codebase |
| Grill with docs | `/bm-kit:grill-with-docs` | Lock down repo language, update `CONTEXT.md` and ADRs |

### Feature execution skills

| Skill | Command | What it does |
|-------|---------|--------------|
| Proto | `/bm-kit:proto` | Generate a self-contained HTML prototype before writing code — grill on what, not how |
| Grill me | `/bm-kit:grill-me` | Stress-test a feature idea through relentless questioning |
| To PRD | `/bm-kit:to-prd` | Synthesize the conversation into a PRD at `.scratch/<feature>/PRD.md` |
| To issues | `/bm-kit:to-issues` | Break a PRD into vertically-sliced issues at `.scratch/<feature>/issues/` |
| Triage | `/bm-kit:triage` | Set issue status: `ready-for-agent`, `needs-info`, `wontfix`, etc. |
| Ralph | `/bm-kit:ralph <feature>` | Run the implementation loop — pick, implement, commit, repeat |
| Wrap | `/bm-kit:wrap <feature>` | Run gap analysis and open a GitHub PR — the final step after ralph |

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
  backlog/
    01-<slug>.md             # Deferred ideas (open / picked-up / done)
    02-<slug>.md
    ...
  <feature-slug>/
    PRD.md                   # Feature spec (written by /bm-kit:to-prd)
    progress.txt             # Feature-scoped implementation learnings
    issues/
      01-<slug>.md           # Issues in dependency order
      02-<slug>.md
      ...
progress.txt                 # Global codebase patterns (project root)
```

### Backlog item status lifecycle

```
open → picked-up (entered the feature workflow) → done
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
