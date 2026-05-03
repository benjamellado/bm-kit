---
name: grill-me
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
---

Read `${CLAUDE_PLUGIN_ROOT}/context/workflow.md` for workflow context.

## Session opening

Before asking the first question, check for open Backlog items:

1. Check if `.scratch/backlog/` exists in the current project.
2. If it does, read all `*.md` files there, parse the frontmatter of each, and collect items where `status: open`. Ignore items with `status: picked-up` or `status: done`.
3. If open items exist, open the session with:

   > What do you want to work on? (You have N open Backlog items: [titles] — want to pick one up, or start something new?)

4. If no open items exist (or `.scratch/backlog/` is absent), open with the standard question:

   > What do you want to work on?

---

## If the user picks a Backlog item

When the user names a Backlog item (by title, ID, or number):

1. Read the full file body of that item from `.scratch/backlog/`.
2. Use the item's body as the starting context for the grilling session — treat it as the plan to interrogate. Skip the usual open-ended opening questions.
3. Dive straight into grilling based on the item's content.

---

## During the session — once a feature slug is established

As soon as the session produces a concrete feature slug (a short kebab-case identifier for the work being grilled), update the chosen Backlog item:

1. Open the Backlog item file.
2. In the frontmatter, set `status: picked-up`.
3. Add a `feature: .scratch/<feature-slug>/` field.
4. Use the Edit tool to write the change.

Only do this if the user picked a Backlog item in the opening. If they started fresh, skip this step.

---

## During the session — adjacency detection

The open Backlog item titles collected in the session opening are ambient context for the entire session. Do not print them again — they are silent.

While grilling, if the discussion topic clearly overlaps with one of those titles, surface it inline without halting the session:

> This looks adjacent to "[Backlog item title]" in your Backlog — want to fold it in or keep them separate?

At that moment, read the full body of that specific item (using Read) to inform follow-up questions if the user wants to fold it in.

Rules:
- Only surface an item when the overlap is clear, not speculative.
- Do not pre-load full bodies of all open items — load one on demand, only when adjacency is detected.
- If `.scratch/backlog/` was absent or empty at session start, skip this step entirely.

---

## During the session — inline parking

While grilling, watch for parking intent from the user. When the user says something like "park this", "save for later", "add to backlog", "let's backlog that", or "keep that for later":

1. **Pause the session.**
2. **Synthesize an enriched Backlog item** from the current conversational thread:
   - **title** — a concise, action-oriented label for the idea or concern just raised
   - **body** with four sections:
     - `## Summary` — one paragraph distilling what was discussed
     - `## Key decisions` — any decisions or stances already taken
     - `## Open questions` — unresolved questions the future session should tackle
     - `## Context` — why this came up, what it was adjacent to
3. **Confirm before writing:**

   > Park this as: "[title]"?

4. **On confirmation:**
   - Determine the next sequence number by listing `.scratch/backlog/` and finding the highest `NNN-` prefix; increment by one (pad to three digits).
   - Write the item to `.scratch/backlog/NNN-<slug>.md` with frontmatter:
     ```
     ---
     id: BL-NNN
     title: "<title>"
     status: open
     created: <today's date>
     ---
     ```
   - Report: `Parked as .scratch/backlog/NNN-<slug>.md`
   - Resume the grilling session from where it was interrupted.
5. **On decline:** discard the synthesized item and resume the session unchanged.

**Important:** the newly parked item must NOT be added to the session's ambient adjacency context. It has just been deferred — treat it as absent for the rest of this session.

---

## Grilling

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time.

If a question can be answered by exploring the codebase, explore the codebase instead.

---

Ready to lock down language? Run `/bm-kit:grill-with-docs`.
