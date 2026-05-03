# understand — Section Reference

One entry per canonical section. The `understand` skill uses this file to know what to extract, where to look, and what to ask the user after extraction.

---

## Purpose

**Auto-extractable:** partial
**Sources:** `README.md`, `package.json` (description field), `pyproject.toml` (description field), `Cargo.toml` (description field)
**Prompt:** "Here's my best-guess purpose statement — does this capture what this codebase is for, or would you refine it?"
**Special rules:** Infer from project description and README intro. Write a single sentence if possible; two sentences max. Mark with `<!-- auto -->`. Encourage human review.

---

## Stack

**Auto-extractable:** yes
**Sources:** `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `Gemfile`, `requirements.txt`, `Dockerfile`, `docker-compose.yml`, `.nvmrc`, `.node-version`, `.tool-versions`
**Prompt:** "I found these technologies — is anything missing or wrong?"
**Special rules:** List languages, frameworks, databases, and infra. Omit dev-only tooling (linters, formatters) unless central to the stack. Mark with `<!-- auto -->`.

---

## Run

**Auto-extractable:** yes
**Sources:** `package.json` (scripts), `Makefile`, `Procfile`, `docker-compose.yml`, `README.md`
**Prompt:** "I found these run commands — is that correct, or would you add anything?"
**Special rules:** Prefer the shortest working command. If multiple run modes exist (e.g. `dev` vs `start`), list both with a one-line note. Mark with `<!-- auto -->`.

---

## Test

**Auto-extractable:** yes
**Sources:** `package.json` (scripts), `Makefile`, `pytest.ini`, `jest.config.*`, `vitest.config.*`, `.github/workflows/`, `README.md`
**Prompt:** "I found these test commands — anything missing?"
**Special rules:** Include how to run a single test if discoverable. Note if no test suite exists. Mark with `<!-- auto -->`.

---

## Architecture

**Auto-extractable:** partial
**Sources:** top-level directory listing, `README.md`, key entry-point files (e.g. `main.*`, `index.*`, `app.*`, `server.*`)
**Prompt:** "Here's my read of the high-level architecture — does this match the actual design, or would you correct it?"
**Special rules:** Describe layers, modules, and key data flows as inferred from the directory structure and entry points. Flag anything unclear rather than guessing. Mark with `<!-- auto -->`. Encourage human review.

---

## Structure

**Auto-extractable:** yes
**Sources:** directory tree (top 2 levels), `README.md`
**Prompt:** "Here's the directory layout I see — anything important that I've mislabelled or missed?"
**Special rules:** Use a short annotated tree (e.g. `src/` — application source). Omit `node_modules`, build artifacts, and hidden cache dirs. Mark with `<!-- auto -->`.

---

## Integrations

**Auto-extractable:** partial
**Sources:** `package.json` / `requirements.txt` / `go.mod` (third-party SDKs), `.env.example`, `docker-compose.yml`, `README.md`, service config files
**Prompt:** "I spotted these external integrations — are there others, or any that aren't active?"
**Special rules:** Surface third-party APIs, databases, and external services. Distinguish runtime integrations from dev tooling. Mark with `<!-- auto -->`. Encourage human review.

---

## Workflow

**Auto-extractable:** partial
**Sources:** `.github/workflows/`, `CONTRIBUTING.md`, `.github/pull_request_template.md`, `README.md`
**Prompt:** "Here's the workflow I inferred — does this match how the team actually works?"
**Special rules:** Cover branch strategy, PR process, and deploy pipeline if discoverable. If CI is absent or unclear, say so rather than inventing a workflow. Mark with `<!-- auto -->`. Encourage human review.

---

## Gotchas

**Auto-extractable:** no
**Sources:** none
**Prompt:** "Anything about this codebase I couldn't read from the files?"
**Special rules:** `understand` never writes this section. Ask one open question only (the prompt above). Do not attempt extraction or suggest candidates. Leave section population entirely to `grill-with-docs` or direct human input.

---

## Note on Language

`Language` is **not** a section `understand` writes or updates. If you encounter recurring domain terms during extraction, surface them as candidates to the user ("I noticed these terms come up often: X, Y, Z — want to define them?") and suggest running `/bm-kit:grill-with-docs` to build the glossary. Never write to the `Language` section.
