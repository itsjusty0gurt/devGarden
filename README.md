# devGarden

**Where ideas grow!**

devGarden is a developer-focused workspace for capturing, organizing, connecting, planning, and developing programming ideas without interrupting the creative process. It is designed to work alongside IDEs, source control, and coding assistants rather than replace them.

## Status

Milestone 0: documentation and architectural decisions. The primary technology direction is accepted, but application implementation has not started.

## Technology direction

devGarden will use Flutter and Dart, targeting Windows desktop first and Android next. Riverpod is accepted for state management, GoRouter for top-level route-based navigation, and SQLite with Drift for local relational persistence. iOS, Linux, and macOS remain possible future platforms; Web would be considered only if later product requirements justify it.

See [ADR 0001](docs/decisions/0001-application-technology-stack.md) for the application stack and [ADR 0002](docs/decisions/0002-local-persistence-with-drift.md) for local persistence. Application implementation has not started.

## Core principles

- Capture first; organize later.
- Keep everything easy to find.
- Prefer familiar, low-friction interactions.
- Adapt the interface to the available space.
- Keep shared content independent of platform-specific presentation.
- Cooperate with developer tools and developer-friendly formats.

## Product hierarchy

`Workspace → Project → App → optional Idea Group → Idea`

An Idea does not require an Idea Group. These are product concepts, not necessarily filesystem folders.

## Documentation

- [Vision](docs/vision.md)
- [Product principles](docs/product-principles.md)
- [Architecture](docs/architecture.md)
- [Conceptual data model](docs/data-model.md)
- [Desktop UI](docs/desktop-ui.md)
- [Mobile UI](docs/mobile-ui.md)
- [Editor and content blocks](docs/editor-and-content-blocks.md)
- [Keyboard and input](docs/keyboard-and-input.md)
- [AI and Codex rules](docs/ai-rules.md)
- [Roadmap and MVP](docs/roadmap.md)
- [Architectural decisions](docs/decisions/README.md)
- [Feature prompt template](docs/prompts/feature-prompt-template.md)
