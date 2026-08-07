# ADR 0002 — Local persistence with Drift

## Status

Accepted

## Date

2026-08-06

## Context

[ADR 0001](0001-application-technology-stack.md) selected SQLite as devGarden's local database technology and deferred the Dart persistence and query layer. devGarden has a strongly relational conceptual model that includes Workspaces, Projects, Apps, Idea Groups, Ideas, Content Blocks, Documents, Flowcharts, Flowchart Nodes, Flowchart Connections, Snippets, Tasks, Tags, Tag Assignments, Relationships, presentation and layout records, and future synchronization metadata.

The persistence layer must serve Windows desktop first and Android next without embedding Windows-only assumptions. Possible later support for iOS, Linux, macOS, and justified Web requirements should remain feasible. Database-opening and bootstrap code may differ by platform behind the persistence boundary.

The application is local-first, not cloud-dependent. Its device database is the durable local source of data, and basic operation must not require cloud infrastructure. A future synchronization system may replicate or reconcile local data, but its provider and protocol are outside this decision.

## Decision

devGarden will use **Drift over SQLite** for local relational persistence. SQLite remains the underlying database technology, and Drift is the accepted Dart persistence and query layer.

Drift is selected because it provides typed Dart queries, strong relational SQLite support, transactions, schema migrations, reactive query support, compile-time query assistance, cross-platform Flutter support, good testability, access to SQLite features where necessary, a maintained path across Windows and Android, and a good fit for devGarden's expected schema complexity.

Reactive queries are a capability, not a universal requirement. They should be used where they provide useful state updates rather than imposed on every query.

Drift's migration facilities will be used for schema evolution. Schema changes must be versioned and migrations explicit. Destructive migrations require strong justification, and user data must never be silently discarded. Upgrade paths and backward compatibility should be considered before release. Material persisted-data changes should be documented, and migration tests should be added when schema evolution begins.

The exact schema, database file location and name, stable identifier format, block payload representation, and backup or recovery strategy are not selected by this ADR.

## Architecture boundaries

The conceptual dependency direction is:

```text
UI / Presentation
        ↓
Application services / use cases
        ↓
Repository interfaces
        ↓
Repository implementations
        ↓
Drift
        ↓
SQLite
```

These boundaries protect the domain from persistence implementation details without requiring unnecessary layers or boilerplate for every feature.

- Flutter widgets must not run Drift queries directly.
- Riverpod providers must not replace repository boundaries.
- Domain entities must remain usable independently of Drift.
- Drift-generated table and data classes must not become the universal domain model.
- Repository implementations may translate between Drift records and domain models.
- Database migrations belong to the persistence layer.
- Persistence errors should be translated into application-appropriate failures instead of leaking raw database exceptions throughout the UI.
- Future synchronization must not require replacing the domain model.

Domain records must use stable sync-capable identities and must not rely solely on SQLite auto-increment integers as externally meaningful identifiers. SQLite internal row identifiers may still be used where helpful. The stable identifier format is **TBD — requires architectural decision before implementation.** No identifier package is selected here.

Trash and soft deletion remain preferred over immediate permanent deletion. The exact Trash schema and retention policy remain open. Foreign keys must be used deliberately, and relationships must not unexpectedly cascade-delete unrelated user content.

Drift and SQLite will persist Content Block metadata and content, but the representation of each payload remains **TBD — block payload persistence and versioning strategy.** That later decision must account for text, formatting metadata, code language, checklist state, embedded object references, Flowchart references, and future block types without prematurely choosing JSON or normalized tables.

Platform presentation records may store explorer side and width, pinboard coordinates, window sizes, collapsed or maximized state, z-order, toolbar preferences, and other platform-specific settings. These records remain separate from core Idea content. Whether layout preferences synchronize between devices is unresolved.

## Alternatives considered

### Drift over SQLite

**Advantages:** Typed relational queries, migration tooling, reactive query support, strong Dart integration, cross-platform support, and a good fit for a large relational schema.

**Disadvantages:** Generated code and build tooling, an additional abstraction over SQLite, Drift-specific conventions to learn, and possible custom SQL for complex SQLite behaviour.

**Decision:** Selected.

### sqflite and sqflite_common_ffi

**Advantages:** Mature SQLite APIs, straightforward CRUD, mobile and desktop support through the sqflite family, and less query abstraction.

**Disadvantages:** More manual query mapping and schema maintenance, less compile-time assistance for a large relational model, and related but distinct desktop and mobile package configuration.

**Decision:** Not selected as the primary persistence layer.

### sqlite3 directly

**Advantages:** Thin SQLite binding, maximum SQL control, cross-platform support, and minimal abstraction.

**Disadvantages:** More manual query code, mapping, migration infrastructure, and maintenance for devGarden's expected schema complexity.

**Decision:** Not selected as the primary application persistence layer.

## Consequences

### Positive

- Persistence queries are strongly typed.
- The relational model has first-class SQLite support.
- SQLite remains portable and inspectable.
- Compile-time assistance reduces the need for raw SQL scattered through application code.
- Drift supplies schema-migration facilities.
- Repository implementations can be tested without the full Flutter UI.
- Windows and Android can share persistence implementation concepts.

### Negative and risks

- Drift adds generated code and build tooling.
- Persistence implementations become internally coupled to Drift.
- Developers must understand both SQL concepts and Drift APIs.
- Schema changes require disciplined migrations.
- Advanced queries may still require raw SQL.

Drift does not remove the need for careful schema, migration, transaction, performance, and platform review.

## Testing direction

When persistence implementation begins, database and repository testing should support in-memory or temporary databases, repository tests without the full Flutter UI, migration tests, transaction behaviour tests, foreign-key and integrity tests, persistence and reload tests, soft-deletion tests, and ordering tests. No tests or database implementation are created by this ADR.

## Follow-up decisions

[ADR 0003](0003-stable-identifiers-with-uuid-v7.md) later resolved the stable identifier format by selecting UUID v7.

Implementation note (2026-08-07): The first product slice introduced Drift schema version 1 for Workspace, Project, App, and Idea. On Windows, `devGarden.sqlite` is stored under the per-user `%APPDATA%\devGarden` directory. Database access is initialized once and remains behind repository interfaces. This note records the later implementation without altering the original decision. The database file location and naming entry in the historical list below is therefore resolved; the other entries remain TBD.

The following remain **TBD — requires architectural decision before implementation:**

- Database file location and naming
- Database backup and recovery
- Block payload persistence and versioning strategy
- Full schema design
- Search indexing and SQLite FTS strategy
- Synchronization metadata
- Synchronization architecture and protocol
- Conflict resolution
- Encryption and privacy model
- Import and export implementation
- Layout-preference synchronization policy

## Principle alignment

- **Capture first:** durable local persistence must save an Idea without requiring organization or metadata.
- **Local-first, not cloud-dependent:** SQLite is the durable device source, and cloud services are not required for basic operation.
- **Shared content, separate presentation:** domain content remains independent of Drift implementation classes and platform-specific layout records.
- **Everything must be easy to find:** relational persistence and later search design have a structured foundation without prematurely choosing an indexing strategy.
- **Work with developer tools:** SQLite remains portable and inspectable while repository boundaries preserve future import, export, and synchronization options.
