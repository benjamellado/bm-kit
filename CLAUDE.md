# Ralph Agent Instructions

You are an autonomous coding agent working on a software project.

## Your Task

The ralph script passes context at the top of your prompt:
- **Feature name** — the feature you're working on
- **Issue file** — the specific `.scratch/<feature>/issues/NN-slug.md` to implement
- **Issues directory** — where all issues for this feature live
- **Feature progress log** — `.scratch/<feature>/progress.txt`
- **Global progress log** — `progress.txt` at the project root

Steps:
1. Read the **issue file** provided above
2. Read the **feature progress log** (check Codebase Patterns section first)
3. Read the **global progress log** (check Codebase Patterns section first)
4. Implement the issue
5. Run quality checks (e.g., typecheck, lint, test — use whatever the project requires)
6. Update CLAUDE.md files if you discover reusable patterns (see below)
7. If checks pass, commit ALL changes with message: `feat: [Issue ID] - [Issue Title]`
8. Update the **issue file**: set `status: done` in the frontmatter
9. Append your progress to the **feature progress log**
10. Append cross-cutting codebase patterns to the **global progress log**

## Progress Report Format

APPEND to the feature progress log (never replace, always append):
```
## [Date/Time] - [Issue ID]
- What was implemented
- Files changed
- **Learnings for future iterations:**
  - Patterns discovered (e.g., "this codebase uses X for Y")
  - Gotchas encountered (e.g., "don't forget to update Z when changing W")
  - Useful context (e.g., "the evaluation panel is in component X")
---
```

The learnings section is critical — it helps future iterations avoid repeating mistakes and understand the codebase better.

## Consolidate Patterns

If you discover a **reusable pattern** that future iterations should know, add it to the `## Codebase Patterns` section at the TOP of the **global** `progress.txt` (create it if it doesn't exist):

```
## Codebase Patterns
- Example: Use `sql<number>` template for aggregations
- Example: Always use `IF NOT EXISTS` for migrations
- Example: Export types from actions.ts for UI components
```

Only add patterns that are **general and reusable**, not story-specific details.

## Update CLAUDE.md Files

Before committing, check if any edited files have learnings worth preserving in nearby CLAUDE.md files:

1. **Identify directories with edited files** — look at which directories you modified
2. **Check for existing CLAUDE.md** — look for CLAUDE.md in those directories or parent directories
3. **Add valuable learnings** — if you discovered something future developers/agents should know:
   - API patterns or conventions specific to that module
   - Gotchas or non-obvious requirements
   - Dependencies between files
   - Testing approaches for that area
   - Configuration or environment requirements

**Examples of good CLAUDE.md additions:**
- "When modifying X, also update Y to keep them in sync"
- "This module uses pattern Z for all API calls"
- "Tests require the dev server running on PORT 3000"
- "Field names must match the template exactly"

**Do NOT add:**
- Story-specific implementation details
- Temporary debugging notes
- Information already in progress.txt

Only update CLAUDE.md if you have **genuinely reusable knowledge** that would help future work in that directory.

## Quality Requirements

- ALL commits must pass the project's quality checks (typecheck, lint, test)
- Do NOT commit broken code
- Keep changes focused and minimal
- Follow existing code patterns

## Browser Testing (If Available)

For any story that changes UI, verify it works in the browser if you have browser testing tools configured (e.g., via MCP):

1. Navigate to the relevant page
2. Verify the UI changes work as expected
3. Take a screenshot if helpful for the progress log

If no browser tools are available, note in your progress report that manual browser verification is needed.

## Stop Condition

After completing the issue, check if ALL issues in the **issues directory** have `status: done`.

If ALL issues are complete and done, reply with:
<promise>COMPLETE</promise>

If there are still issues with `status: ready-for-agent`, end your response normally (the next ralph iteration will pick up the next issue).

## Important

- Work on ONE issue per iteration (the one provided in the context above)
- Commit after completing the issue
- Keep CI green
- Read the Codebase Patterns sections in both progress logs before starting

## Agent skills

### Issue tracker

Issues live as local markdown files under `.scratch/`. See `docs/agents/issue-tracker.md`.

### Triage labels

Default five-role vocabulary (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`, `done`). See `docs/agents/triage-labels.md`.

### Domain docs

Single-context repo — one `CONTEXT.md` + `docs/adr/` at the root. See `docs/agents/domain.md`.
