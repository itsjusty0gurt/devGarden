# devGarden agent instructions

Before changing the product or architecture, read `README.md` and the relevant files in `docs/`. Treat them as the source of truth.

- Preserve the exact name **devGarden** and motto **Where ideas grow!**
- Do not invent requirements. Mark unresolved choices: **TBD — requires architectural decision before implementation.**
- Preserve capture-first: an Idea must be writable and saveable before metadata or organization.
- Keep shared content independent of desktop-only or mobile-only presentation state.
- Prefer focused extensions of existing systems; avoid unrelated rewrites or refactors.
- Reuse existing components, services, models, and utilities before adding new ones. Keep modules focused.
- Follow familiar developer-tool patterns, accessibility practices, and keyboard navigation. Avoid decorative animation.
- Keep user-facing strings localizable and import/export formats developer-friendly; avoid proprietary lock-in where practical.
- Never silently delete user data or migrations. Prefer Trash, reversible migrations, and explicit transformations.
- Do not implement roadmap features outside the active milestone. Build the smallest complete vertical slice.
- Record significant choices as ADRs in `docs/decisions/` and preserve settings and saved layouts across upgrades where practical.
- Add or update tests when behaviour changes. Run relevant validation; never claim unrun or failed tests passed.
- If a request conflicts with a non-negotiable principle, stop and report it.
- Report files changed, design decisions, validation, test results, limitations, and remaining questions.
