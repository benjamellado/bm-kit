---
name: understand
description: Extract codebase knowledge section by section, confirm with the user, and write it into CONTEXT.md. Works as a first-pass onboarding tool and as a periodic refresh. Use when the user runs /bm-kit:understand or wants to populate/update their CONTEXT.md.
allowed-tools: Read, Glob, Grep, Bash, Edit, Write
---

Read `${CLAUDE_PLUGIN_ROOT}/skills/understand/SECTIONS.md` and `${CLAUDE_PLUGIN_ROOT}/skills/grill-with-docs/CONTEXT-FORMAT.md` before proceeding.

Read `CONTEXT.md` (if it exists) and classify each canonical section:
- **empty** — heading present but no content below it (or section absent entirely)
- **auto** — has an `<!-- auto -->` tag on the line immediately after the heading
- **reviewed** — has a `<!-- reviewed -->` tag on the line immediately after the heading

---

## Opening move

Ask: "Is there something specific you want to update?"

**If yes** → Ask "What section or topic?" → jump to that section → run the per-section loop for it only → skip to the end.

**If no** → Walk all sections in order: empty first, then `<!-- auto -->`, then `<!-- reviewed -->` (lightly).

---

## Per-section loop

For each section in scope (except Gotchas — see below):

1. **Extract silently** — read the sources listed in `SECTIONS.md` for that section
2. **Present findings** — show a draft with the exact prompt from `SECTIONS.md`
3. **Confirm** — wait for the user's response:
   - User confirms as-is → write the section body with `<!-- reviewed -->` tag
   - User provides corrections or additions → incorporate them → write with `<!-- auto -->` tag
   - User skips → do not write; move on
4. Move to the next section

Tag placement: the tag goes on the line **immediately after** the section heading, before the content. See `CONTEXT-FORMAT.md` for the exact format.

---

## Language (never write this section)

After completing the section walk, scan the extractions for recurring domain terms. Surface candidates only:

> "I noticed these terms come up often: X, Y, Z. Want to define any, or save that for `/bm-kit:grill-with-docs`?"

Never write to the `Language` section. If the user wants to define terms now, suggest `/bm-kit:grill-with-docs`.

---

## Gotchas (conversation-only)

End with one open question:

> "Anything about this codebase I couldn't read from the files?"

Do not attempt extraction or suggest candidates. Leave writing this section entirely to the user or `/bm-kit:grill-with-docs`.

---

## End message

After all sections are complete:

> CONTEXT.md updated. Run `/bm-kit:grill-with-docs` to refine domain language.
