---
name: wrap
description: Close out a feature after the ralph loop by running pre-flight gap analysis and opening a PR. Use when user wants to wrap up a feature, open a PR, or review what was built vs planned.
allowed-tools: Bash, Read
---

Read `${CLAUDE_PLUGIN_ROOT}/context/workflow.md` to understand where this skill fits in the bm-kit pipeline.

## Usage

```
/bm-kit:wrap <feature-slug>
```

`<feature-slug>` is the directory name under `.scratch/` (e.g. `my-feature` for `.scratch/my-feature/`).

---

## Phase 1: Pre-flight

### Read the feature artifacts

Read all three sources before doing anything else:

1. `.scratch/<feature-slug>/PRD.md` — the original feature spec
2. All files matching `.scratch/<feature-slug>/issues/*.md` — every issue, regardless of status
3. `.scratch/<feature-slug>/progress.txt` — the implementation log

Also read `CONTEXT.md` if it exists — you will need the **Test** section when building the PR description.

### Run gap analysis

Cross-reference the three sources:

1. **PRD goals vs issues** — identify any goal or user story in the PRD that has no corresponding issue
2. **Issues vs progress entries** — for each issue, check whether progress.txt contains a corresponding entry; flag any issue that has a progress entry missing
3. **Non-done issues** — list every issue whose `status` field is not `done`

### Present the pre-flight report

Output a structured report:

```
## Pre-flight report: <feature-slug>

### What was built
- <one line per done issue, synthesized from the progress entry for that issue>

### Gaps detected
- <PRD goals with no corresponding issue>
- <Done issues with no progress entry>

### Issues not in done status
- <issue ID> — <title> — status: <status>
  (none if all issues are done)
```

Then ask:

> Create PR?

**If the developer answers no:** End the skill immediately. Do not open a PR, do not modify any files. Tell the developer they can fix gaps and re-run `/bm-kit:wrap <feature-slug>` when ready.

**If the developer answers yes:** Proceed to Phase 2.

---

## Phase 2: Branch confirmation

This phase fires **immediately before** calling `gh pr create` — not at skill start.

Run these commands to read the current state:

```bash
git branch --show-current
git remote show origin | grep 'HEAD branch' | awk '{print $NF}'
```

If the second command fails (no remote or ambiguous), fall back to asking the developer for the default branch name.

Then ask:

> PR from `<current-branch>` into `<default-branch>` — correct, or different target?

- If the developer confirms (yes / enter / correct): use `<default-branch>` as the target.
- If the developer names a different branch: use that branch as the target.

---

## Phase 3: PR creation

### Build the PR description

The description must contain exactly these four sections:

#### 1. What was built

One line per done issue, synthesized from progress entries. Use the issue title and the key implementation points from the progress log. Example format:

```
- **WRP-01 Create wrap skill** — added `skills/wrap/SKILL.md` with pre-flight, branch confirmation, and PR creation phases
```

#### 2. How to test it

A markdown checklist. Infer test steps from:
- Acceptance criteria in each issue
- Testing decisions in the PRD
- The `## Test` section of `CONTEXT.md` (if present)

Format:

```
- [ ] <test step>
- [ ] <test step>
```

#### 3. Known limitations

The gaps and non-done issues surfaced by the gap analysis. If the gap analysis found nothing, write: `None detected.`

#### 4. Commits

Run this command to get the raw commit log since the feature branch diverged from the target branch:

```bash
git log <target-branch>..HEAD --oneline
```

Include the raw output verbatim, formatted as a code block.

---

### Push branch if needed

Before creating the PR, check whether the current branch has a remote tracking branch:

```bash
git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null
```

If this command fails (exit code non-zero), the branch has no upstream — push it first:

```bash
git push -u origin <current-branch>
```

If it succeeds, the branch is already on the remote — skip the push.

### Run gh pr create

Use a HEREDOC to pass the body:

```bash
gh pr create \
  --base <target-branch> \
  --title "<synthesized title>" \
  --body "$(cat <<'EOF'
## What was built

<content>

## How to test it

<content>

## Known limitations

<content>

## Commits

\`\`\`
<git log output>
\`\`\`
EOF
)"
```

The PR title should be a short (under 70 characters) summary of the feature — synthesize it from the PRD title or the feature slug.

After `gh pr create` succeeds, output the PR URL returned by the command.

---

## Read-only constraint

This skill must **not** modify any files under `.scratch/`. Do not update issue statuses, do not append to progress logs. The wrap skill is purely diagnostic and additive (opens a PR); all `.scratch/` state is left exactly as found.
