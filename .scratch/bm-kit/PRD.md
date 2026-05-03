---
status: needs-triage
type: prd
---

# bm-kit — AI-Assisted Dev Workflow Plugin

## Problem Statement

Building software with AI assistance today requires juggling multiple disconnected tools: one for planning and grilling ideas, another for breaking work into issues, another for tracking triage state, and yet another for running autonomous implementation loops. These tools were designed independently, output to different places (GitHub issues, local JSON files, markdown), and have no shared understanding of the overall workflow. The result is friction at every handoff — especially between the planning phase and the implementation loop, where work created in one format has to be manually translated into another before an agent can act on it.

## Solution

`bm-kit` is a personal Claude Code plugin that unifies the full AI-assisted development workflow — from raw idea to shipped code — into a single installable toolkit. It provides namespaced slash commands for every phase of the workflow (`/bm-kit:grill-me`, `/bm-kit:to-prd`, `/bm-kit:ralph`, etc.) and uses a single local source of truth: `.scratch/` markdown files. Planning skills write to `.scratch/`. The implementation loop reads from `.scratch/`. There is no translation step.

The plugin is installed once globally. Any project gets the full toolkit via `/bm-kit:init`.

## User Stories

1. As a developer, I want to install bm-kit with a single command, so that I get all workflow skills globally without per-project setup.
2. As a developer, I want to run `/bm-kit:init` in any project, so that the project is set up with `.scratch/`, `CONTEXT.md`, and `docs/adr/` structure ready for bm-kit workflow.
3. As a developer, I want to run `/bm-kit:grill-me` to stress-test a feature idea, so that I surface assumptions and design decisions before writing any code.
4. As a developer, I want `/bm-kit:grill-me` to suggest the next step at the end of the session, so that I know to continue with `/bm-kit:grill-with-docs`.
5. As a developer, I want to run `/bm-kit:grill-with-docs` to lock down terminology and update `CONTEXT.md`, so that my domain language stays consistent across the codebase.
6. As a developer, I want to run `/bm-kit:to-prd` to synthesize the grilling conversation into a PRD, so that I have a structured document capturing the feature scope.
7. As a developer, I want `/bm-kit:to-prd` to write the PRD to `.scratch/feature/PRD.md`, so that it lives locally alongside the issues that will implement it.
8. As a developer, I want to run `/bm-kit:to-issues` to break a PRD into vertically-sliced issues, so that each issue is independently implementable by an agent.
9. As a developer, I want `/bm-kit:to-issues` to write issues to `.scratch/feature/issues/NN-slug.md` with frontmatter fields (`id`, `title`, `status`, `priority`), so that the ralph loop can read and execute them directly.
10. As a developer, I want to run `/bm-kit:triage` on an issue, so that I can mark it `ready-for-agent`, `ready-for-human`, `needs-info`, or `wontfix`.
11. As a developer, I want the triage skill to read and write the `status` field in the issue's frontmatter, so that all state lives in the same file.
12. As a developer, I want to run `/bm-kit:ralph feature-name` to start the implementation loop for a feature, so that all `ready-for-agent` issues are implemented one by one by Claude.
13. As a developer, I want the ralph loop to pick issues in filename order (`01-`, `02-`, etc.), so that dependency order is enforced without a separate priority system.
14. As a developer, I want the ralph loop to mark each completed issue `status: done` in its frontmatter, so that progress is visible in the issue file itself.
15. As a developer, I want the ralph loop to append learnings to a feature-scoped `progress.txt` inside `.scratch/feature/`, so that story-specific context accumulates there.
16. As a developer, I want the ralph loop to append cross-cutting codebase patterns to a global `progress.txt` at the project root, so that future ralph runs on any feature benefit from past discoveries.
17. As a developer, I want every bm-kit skill to load a shared workflow context file, so that each skill understands where it fits in the full pipeline without duplicating that knowledge.
18. As a developer, I want every skill to suggest the next step at the end of its output, so that I always know what to run next without memorising the pipeline.
19. As a developer, I want to run `/bm-kit:improve-codebase-architecture` to find refactoring opportunities, so that I can keep the codebase clean between features.
20. As a developer, I want to run `/bm-kit:diagnose` to debug hard bugs systematically, so that I have a disciplined process for reproducing, minimising, and fixing issues.
21. As a developer, I want to run `/bm-kit:tdd` to build features test-first, so that I have coverage on critical paths.
22. As a developer, I want to run `/bm-kit:write-a-skill` to create new bm-kit skills, so that I can extend the toolkit over time.
23. As a developer, I want to run `/bm-kit:caveman` to compress AI output, so that I reduce token usage when I want terse responses.
24. As a developer, I want the plugin to be its own independent repository (not a fork), with a clean README that credits the original Ralph and Matt Pocock skills repos, so that the project has clear ownership and acknowledges its inspirations.
25. As a developer, I want the README to explain the full workflow with the skill pipeline clearly documented, so that I can onboard myself back into the system after time away.

## Implementation Decisions

### Plugin Structure
- Plugin name: `bm-kit` (namespace for all skills)
- All skills consolidated under top-level `skills/` directory (not `.agents/skills/`)
- Plugin manifest at `.claude-plugin/plugin.json` updated with new name and skills path
- Ralph loop script lives at `scripts/ralph.sh` inside the plugin, invoked via `${CLAUDE_PLUGIN_ROOT}/scripts/ralph.sh`
- No script copying to projects — script runs from plugin installation directory

### Shared Workflow Context
- Single file at `context/workflow.md` describing the full bm-kit pipeline
- Every skill SKILL.md begins by loading this file via `${CLAUDE_PLUGIN_ROOT}/context/workflow.md`
- One file to update; all skills pick up changes automatically

### `.scratch/` Issue Format
- Feature directory: `.scratch/feature-slug/`
- PRD document: `.scratch/feature-slug/PRD.md`
- Issues: `.scratch/feature-slug/issues/NN-slug.md`
- Feature progress log: `.scratch/feature-slug/progress.txt`
- Global progress log: `progress.txt` at project root
- Issue frontmatter fields: `id`, `title`, `status`, `priority`
- Valid status values: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`, `done`
- Filename ordering (`01-`, `02-`) encodes dependency order — no separate priority sorting needed

### Ralph Loop Script
- Invocation: `./ralph.sh <feature-name> [--tool claude]` (claude is default, codex deferred)
- Reads issues from `.scratch/<feature-name>/issues/` where `status: ready-for-agent`
- Picks lowest-numbered file (filename order = dependency order)
- After successful implementation: sets `status: done` in issue frontmatter
- Appends learnings to `.scratch/<feature-name>/progress.txt` (feature-scoped)
- Appends cross-cutting patterns to `progress.txt` at project root (global)
- Stop condition: output contains `<promise>COMPLETE</promise>` OR no more `ready-for-agent` issues

### Agent Instructions (CLAUDE.md)
- Rewritten to read from `.scratch/` instead of `prd.json`
- Same iteration model: one issue per session, commit on pass, update status to `done`
- Progress report format preserved

### Skills to Rewrite
- `grill-me`, `grill-with-docs`: preserve core prompting logic, add context load + next-step suggestion
- `to-prd`: write to `.scratch/feature/PRD.md`, apply `needs-triage` status
- `to-issues`: write to `.scratch/feature/issues/NN-slug.md` with correct frontmatter
- `triage`: operate on `.scratch/` frontmatter status fields (not GitHub labels)
- `init`: new skill — creates `.scratch/`, `CONTEXT.md`, `docs/adr/` in current project
- `ralph`: new skill — invokes `${CLAUDE_PLUGIN_ROOT}/scripts/ralph.sh` with feature name
- `improve-codebase-architecture`, `diagnose`, `tdd`, `write-a-skill`, `caveman`: add context load, minimal changes

### Repository Migration
- Remove GitHub fork relationship
- Update remote origin to `https://github.com/benjamellado/bm-kit.git`
- New README crediting original repos:
  - Ralph: https://github.com/snarktank/ralph
  - Matt Pocock Skills: https://github.com/mattpocock/skills

## Testing Decisions

No automated tests for this project. bm-kit is a personal toolkit; skills are prompts and the ralph loop is a bash orchestration script. Correctness is validated by using the tools on real projects.

## Out of Scope

- Codex support in the ralph loop (deferred — not enough familiarity with Codex CLI interface yet)
- Multi-agent parallelism (running multiple issues simultaneously)
- GitHub integration (issues, PRs, labels) — fully local by design
- A meta-skill that orchestrates the full pipeline automatically
- Automated tests for skills or scripts

## Further Notes

- The `setup-matt-pocock-skills` skill from the original `.agents/skills/` is superseded by `/bm-kit:init`
- The old `skills/prd/` and `skills/ralph/` (ralph's original PRD generator and prd.json converter) are obsolete and should be removed
- The flowchart React app (`/flowchart/`) can be kept as documentation but is not part of the plugin
- The `zoom-out` skill from `.agents/skills/` was not included in bm-kit — can be added later if needed
- bm-kit is intentionally personal — it is not designed as a generic open-source tool, though others may fork it
