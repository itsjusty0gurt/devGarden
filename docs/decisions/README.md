# Architectural Decision Records

Significant architectural choices for devGarden must be recorded as Architectural Decision Records (ADRs). ADRs explain why a choice was made, preserve considered alternatives, and keep future sessions from silently revisiting settled ground.

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

## Follow-up work

What actions or later decisions remain?
```

Do not record speculation as accepted. Link ADRs from [architecture](../architecture.md) and update affected source-of-truth documents when a decision changes requirements.
