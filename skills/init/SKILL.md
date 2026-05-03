---
name: init
description: Bootstrap a project for the bm-kit workflow. Creates .scratch/, CONTEXT.md, docs/adr/, and progress.txt in the current project if they don't exist. Use when starting bm-kit in a new project.
allowed-tools: Bash, Write
---

Read `${CLAUDE_PLUGIN_ROOT}/context/workflow.md` to understand the full bm-kit pipeline before proceeding.

Set up the current project for bm-kit by creating the following structure (skip anything that already exists):

1. `.scratch/` directory — where all feature PRDs, issues, and progress logs live
2. `CONTEXT.md` at the project root — domain glossary and architecture decisions stub
3. `docs/adr/` directory — Architecture Decision Records
4. `progress.txt` at the project root — global codebase patterns log

For `CONTEXT.md`, create this stub if the file doesn't exist:
```markdown
# Context

## Domain Glossary

<!-- Add domain terms and their definitions here -->

## Architecture

<!-- Add high-level architecture notes here -->
```

For `progress.txt`, create this stub if the file doesn't exist:
```
## Codebase Patterns

<!-- Cross-cutting patterns discovered during implementation go here -->

---
```

After creating all files, report what was created vs what already existed.

End with:

> Project initialised. Run `/bm-kit:grill-me` to start your first feature.
