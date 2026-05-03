---
name: to-prd
description: Turn the current conversation context into a PRD and save it to .scratch/<feature-slug>/PRD.md. Use when user wants to create a PRD from the current context.
allowed-tools: Bash, Read, Write
---

Read `${CLAUDE_PLUGIN_ROOT}/context/workflow.md` to understand the full bm-kit pipeline and where this skill fits.

This skill synthesises the current conversation into a structured PRD and saves it locally. Do NOT interview the user — synthesize what you already know from the conversation.

## Process

1. **Determine the feature slug.**
   - Infer it from the conversation topic (e.g. "user auth flow" → `user-auth-flow`).
   - If unclear, ask: "What slug should I use for this feature? (e.g. `user-auth-flow`)"
   - The slug becomes the directory name under `.scratch/`.

2. **Explore the repo** to understand the current codebase state. Use the project's domain glossary (from `CONTEXT.md` if present) and respect any ADRs in `docs/adr/`.

3. **Write the PRD** to `.scratch/<feature-slug>/PRD.md` using the template below. Include `status: needs-triage` in the frontmatter.
   - Create the directory if it doesn't exist (`mkdir -p .scratch/<feature-slug>`).
   - No GitHub API calls — write the file directly with the Write tool.

4. **End with:**
   > PRD saved to `.scratch/<feature-slug>/PRD.md`. Run `/bm-kit:to-issues` to break it into issues.

---

## PRD template

```markdown
---
status: needs-triage
type: prd
---

# <Feature Name>

## Problem Statement

<The problem the user is facing, from the user's perspective.>

## Solution

<The solution, from the user's perspective.>

## User Stories

<A numbered list of user stories. Each in the format: "As a <actor>, I want <feature>, so that <benefit>." Be extensive — cover all aspects of the feature.>

1. As a ..., I want ..., so that ...
2. ...

## Implementation Decisions

<Implementation decisions made. Include: modules to build/modify, architectural decisions, schema changes, API contracts, specific interactions. Do NOT include specific file paths or code snippets.>

## Testing Decisions

<Testing decisions. Include: what makes a good test for this feature, which modules will be tested, prior art in the codebase.>

## Out of Scope

<Things explicitly not included in this PRD.>

## Further Notes

<Any additional context.>
```
