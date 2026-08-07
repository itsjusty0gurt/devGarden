# AI and Codex rules

## Source of truth

Before architectural or product work, inspect the repository and read the relevant documentation. Treat it as the current source of truth. When it is silent, do not invent a requirement; write **TBD — requires architectural decision before implementation.** Ask only when repository context cannot safely resolve a material ambiguity.

Preserve the exact product name **devGarden** and motto **Where ideas grow!**

## Product safeguards

- Preserve capture-first. Never require metadata or organization before an Idea can be written and saved.
- Preserve the hierarchy `Workspace → Project → App → optional Idea Group → Idea` and allow ungrouped Ideas.
- Keep shared content independent of desktop-only layout data and preserve platform-specific presentation where desktop and mobile differ.
- Follow familiar developer-tool patterns, maintain accessibility and keyboard navigation, and avoid unnecessary animation.
- Keep import/export developer-friendly and avoid proprietary lock-in where practical.
- Do not implement speculative systems solely because they appear in the [roadmap](roadmap.md).
- If a request conflicts with a [non-negotiable principle](product-principles.md), stop and report the conflict.

## Change discipline

- Prefer extending existing systems over replacing them. Do not rewrite working code without a documented reason.
- Keep changes focused; avoid unrelated refactoring.
- Reuse existing components, services, models, and utilities before creating new ones. Keep modules focused and reasonably small.
- Build the smallest complete vertical slice for the active milestone.
- Avoid scattering hardcoded user-facing strings; keep localization possible.
- Record significant choices as [Architectural Decision Records](decisions/README.md).

## Data safety and compatibility

- Never silently delete user data or migrations.
- Prefer Trash, soft deletion, reversible migrations, and explicit transformations.
- Preserve saved layouts and user settings across upgrades where practical.
- Do not let relationships silently cascade-delete unrelated content.
- Preserve conflicts rather than silently losing work.

## Validation and reporting

Add or update tests when implementation changes behaviour. Run validation appropriate to risk and never claim a test passed unless it actually ran and passed. Report:

- Files changed
- Important design decisions
- Validation performed and commands used
- Test results
- Known limitations
- Remaining questions

These long-form rules are summarized operationally in the repository root `AGENTS.md`.
