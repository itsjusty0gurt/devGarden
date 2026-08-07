# Architecture direction

## Status

The primary application technology direction is accepted in [ADR 0001](decisions/0001-application-technology-stack.md). Application implementation has not started.

## Confirmed technology direction

- **Application framework:** Flutter
- **Primary language:** Dart
- **Initial platform:** Windows desktop
- **Planned next platform:** Android
- **Potential future platforms:** iOS, Linux, and macOS; Web only if later product requirements justify it
- **State management:** Riverpod
- **Route-based navigation:** GoRouter
- **Local database technology:** SQLite
- **Dart persistence and query layer:** Drift

See [ADR 0001](decisions/0001-application-technology-stack.md) and [ADR 0002](decisions/0002-local-persistence-with-drift.md).

## Architectural constraints

- Desktop and mobile share the conceptual content model while keeping presentation platform-specific.
- Shared Idea content must never depend on desktop pinboard coordinates, explorer placement, or other layout state.
- Capture and offline persistence must avoid data loss. A new Idea can be saved before organization.
- Mobile must eventually create and edit offline, persist locally, reopen safely, queue synchronization, and preserve conflicting versions.
- Stable identifiers, explicit ordering, versioned block payloads, and non-destructive deletion support later sync and evolution.
- Project Documents and future imports/exports should cooperate with normal developer files, especially Markdown.
- The initial individual-user design must not unnecessarily prevent future collaboration.
- Platform-specific UI should adapt by available space; see [desktop UI](desktop-ui.md) and [mobile UI](mobile-ui.md).

## Conceptual layers

The implementation will separate at least these responsibilities:

1. **Domain models:** hierarchy, Ideas, Documents, blocks, Flowcharts, Snippets, Tasks, Tags, and Relationships.
2. **Application services and use cases:** capture, organization, lifecycle, validation, search, import/export, and future synchronization behaviour.
3. **Persistence repositories:** abstract access to local data and future synchronized data.
4. **Presentation state:** current navigation, selection, editing, and platform-specific layout state.
5. **Platform-specific UI:** desktop menus, explorer, pinboard, status bar; mobile navigation, lists, and focused editors.
6. **Shared reusable UI components:** suitable controls shared without forcing identical platform layouts.

These are responsibilities, not a prescribed code structure.

Desktop and mobile share domain models, core application logic, persistence abstractions, content structures, validation rules, search and synchronization concepts, and business rules. They may differ substantially in navigation, layout, pinboard behaviour, panel placement, window management, toolbar and status presentation, editing surfaces, and interaction density.

UI widgets must not directly own persistence logic or run Drift queries. Persistence is accessed through repository interfaces, and the eventual synchronization layer must not be tightly coupled to widgets. Riverpod providers do not replace repository boundaries. Domain models remain independent of Drift-generated types, and shared Idea content must not contain desktop-only pinboard coordinates or depend on platform presentation state.

Riverpod exposes application and presentation state without replacing domain, application-service, or repository boundaries. State organization remains modular, and business rules do not live directly in UI widgets.

GoRouter handles top-level route-based navigation. Desktop pinboard windows do not need to be represented entirely as routes; internal workspace state may remain local presentation state where appropriate. The full route tree and provider organization are not designed in this milestone.

## Local persistence direction

SQLite is the local database technology, with Drift as the Dart persistence and query layer. Repository implementations may translate between Drift records and domain models. Database-opening and bootstrap details may vary by platform behind the persistence boundary, but the persistence layer must not assume Windows-only behaviour.

The local database is the device's durable source of data. devGarden remains local-first, not cloud-dependent, and must operate offline without cloud infrastructure. Schema and persistence design must support stable identifiers, explicit ordering, created and updated timestamps, soft deletion or Trash, versioned content blocks, future synchronization metadata and conflict handling, and platform-specific layout data stored separately from shared content.

Drift migration facilities will support explicit, versioned schema evolution. Destructive migrations require strong justification and must never silently discard user data. Foreign keys and cascade behaviour must be designed deliberately. Drift-generated types are persistence implementation details, not shared domain models by default.

## Offline and synchronization direction

Local work must remain safe when disconnected. Eventual synchronization must detect conflicts and preserve both versions rather than silently overwrite work. Authentication, transport, server, merge rules, encryption, and recovery are unresolved. No cloud provider or business model is assumed.

## Open decisions

Every item below is **TBD — requires architectural decision before implementation.** Record each accepted choice in [Architectural Decision Records](decisions/README.md).

- Stable identifier format
- Database file location and naming
- Database backup and recovery strategy
- Full relational schema design
- Block payload persistence and versioning strategy
- Synchronization metadata design
- Synchronization architecture
- Authentication strategy
- Cloud provider, if any
- Rich-text or block-editor framework
- Desktop pinboard implementation
- Flowchart library
- Search indexing and SQLite FTS strategy
- Import and export implementation details
- Layout-preference synchronization policy
- Packaging and distribution details
- App-store strategy
- Licensing
- Update mechanism
- Telemetry and crash reporting policy
- Collaboration model
- Conflict resolution
- Encryption and privacy model

## Known design tensions

The interface differences, local-first versus future cloud sync, flexible blocks versus Markdown export, customization versus consistency, and Snippets versus embedded code must be resolved without weakening the [product principles](product-principles.md). The meaning and required scope of an Inbox when no App is selected also needs a product decision.
