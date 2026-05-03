---
name: ralph
description: Run the ralph implementation loop for a feature. Invokes ralph.sh to pick ready-for-agent issues one by one, implement them, and mark them done. Use with /bm-kit:ralph <feature-slug>.
allowed-tools: Bash
---

Read `${CLAUDE_PLUGIN_ROOT}/context/workflow.md` to understand the full bm-kit pipeline before proceeding.

## Usage

```
/bm-kit:ralph <feature-slug>
```

`<feature-slug>` is the directory name under `.scratch/` (e.g. `my-feature` for `.scratch/my-feature/`).

## What this does

1. Scans `.scratch/<feature-slug>/issues/` for files with `status: ready-for-agent`
2. Picks issues in filename order (`01-`, `02-`, ...) — this is the dependency order
3. Runs Claude on each issue in sequence via `ralph.sh`
4. Marks each completed issue `status: done` in its frontmatter
5. Stops when all `ready-for-agent` issues are done or the agent outputs `<promise>COMPLETE</promise>`

## Before starting

Show the user which issues are queued:

```bash
grep -l 'status: ready-for-agent' .scratch/<feature-slug>/issues/*.md 2>/dev/null | sort
```

List them with their titles so the user knows what's about to run.

If no `ready-for-agent` issues exist, tell the user and suggest running `/bm-kit:triage` first.

## Ask for iteration limit

After listing issues, count them (call the count X) and ask:

> Run all X issues, or enter a limit [all]:

Wait for the user's response before proceeding:
- If the user enters a positive integer N, record `--max N` to pass to the script.
- If the user presses enter (empty response) or types "all", run without `--max` (default behaviour).

## Running the loop

If the user provided a limit N:

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/ralph.sh <feature-slug> --max N
```

Otherwise:

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/ralph.sh <feature-slug>
```

Stream output to the terminal so progress is visible.

## After the loop

End with:

> Check `.scratch/<feature-slug>/progress.txt` for learnings from this run.
>
> If any issues remain, run `/bm-kit:triage` to review them, then `/bm-kit:ralph <feature-slug>` again.
