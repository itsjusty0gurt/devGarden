# Architectural Decision Records

Significant architectural choices for devGarden must be recorded as Architectural Decision Records (ADRs). ADRs explain why a choice was made, preserve considered alternatives, and keep future sessions from silently revisiting settled ground.

## Accepted decisions

- [ADR 0001 — Application technology stack](0001-application-technology-stack.md) — Flutter, Dart, Windows first, Android next, Riverpod, GoRouter, and SQLite
- [ADR 0002 — Local persistence with Drift](0002-local-persistence-with-drift.md) — Drift over SQLite behind repository interfaces

Use sequential filenames:

```text
0001-short-decision-title.md
0002-another-decision.md
```

## Template

```markdown
# Title

## Status

Proposed | Accepted | Superseded | Deprecated

## Date

YYYY-MM-DD

## Context

What problem, constraints, and evidence require a decision?

## Decision

What has been decided?

## Alternatives considered

What credible alternatives were evaluated and why were they not selected?

## Consequences

What becomes easier, harder, constrained, or newly required?

## Follow-up work or decisions

What actions or later decisions remain?

## Principle alignment

How does the decision preserve or advance the non-negotiable product principles?
```

Do not record speculation as accepted. Link ADRs from [architecture](../architecture.md) and update affected source-of-truth documents when a decision changes requirements.
