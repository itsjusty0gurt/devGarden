# Conceptual data model

This document describes conceptual entities rather than final Drift tables. SQLite with Drift is accepted for local relational persistence by [ADR 0001](decisions/0001-application-technology-stack.md) and [ADR 0002](decisions/0002-local-persistence-with-drift.md). The final schema, database file details, migrations, identifier format, and serialization remain **TBD — requires architectural decision before implementation.** Domain models must not depend directly on Drift-generated table or data classes.

## Hierarchy and ownership

`Workspace → Project → App → optional Idea Group → Idea`

An Idea belongs to an App but may omit an Idea Group. Workspace, Project, App, and Idea Group are product concepts, not necessarily filesystem directories.

## Core entities

### User

Represents an owner or future collaborator. Authentication details are not defined.

### Workspace

`id`, `name`, `description`, `sort order`, `archived state`, `created timestamp`, `updated timestamp`.

### Project

`id`, `workspace id`, `name`, `description`, `sort order`, `archived state`, `created timestamp`, `updated timestamp`.

### App

`id`, `project id`, `name`, `description`, `sort order`, `archived state`, `created timestamp`, `updated timestamp`.

### Idea Group

`id`, `app id`, `name`, `description`, `sort order`, `archived state`, `created timestamp`, `updated timestamp`.

### Idea

`id`, `app id`, optional `idea group id`, `title`, `lifecycle status`, `priority`, `impact`, `complexity`, `pinned state`, `archived state`, `created timestamp`, `updated timestamp`, optional `completion timestamp`.

The default lifecycle is Idea, Approved, Planned, Building, Complete, Rejected, and Archived. It may later be customizable. Potential impact values are Small feature, UI change, New system, Architecture change, and Product-level change. Architecture changes must be identifiable. None of this metadata is required before capture.

### Content Block

`id`, `owning object type`, `owning object id`, `block type`, `sort order`, `content payload`, language or format metadata where relevant, `payload version`, `created timestamp`, `updated timestamp`.

### Document

`id`, `project id` or `app id`, optional `idea group id`, `title`, `document type or template`, `archived state`, `created timestamp`, `updated timestamp`.

### Flowchart

`id`, `owning scope`, `title`, `archived state`, `created timestamp`, `updated timestamp`.

### Flowchart Node

`id`, `flowchart id`, `node type`, `label`, `position`, optional `linked object type`, optional `linked object id`, `metadata`.

### Flowchart Connection

`id`, `flowchart id`, `source node id`, `target node id`, `label`, `connection type`, `metadata`.

### Snippet

`id`, `owning scope`, `title`, `language`, `code`, `description`, `archived state`, `created timestamp`, `updated timestamp`.

A Snippet is reusable and independently managed. It is not an inline Content Block.

### Task

`id`, `owning object type`, `owning object id`, `title`, `completed state`, `sort order`, optional future `due date`, `created timestamp`, `updated timestamp`.

### Tag and Tag Assignment

Tag: `id`, `name`, optional `colour`, `created timestamp`.

Tag Assignment: `tag id`, `object type`, `object id`.

### Relationship

`id`, `source object type`, `source object id`, `target object type`, `target object id`, `relationship type`, optional `label`, `created timestamp`.

## Presentation entities

### Project Layout Preference

`platform`, `user`, `explorer side`, `explorer width`, `toolbar configuration`, `status-bar configuration`, and other platform-specific settings.

### Pinboard Layout

`user`, `app or idea group`, `idea id`, `x`, `y`, `width`, `height`, `collapsed state`, `maximized state`, `z order`, `pinned state`, `platform`.

These entities are presentation data. Desktop layout state must never be embedded in core Idea content or required by mobile.

## Integrity and evolution rules

- Use stable identifiers.
- Do not rely solely on SQLite auto-increment integers as externally meaningful or sync-capable identity. The stable identifier format remains **TBD — requires architectural decision before implementation.**
- Use explicit sort order; timestamps alone do not define order.
- Prefer Trash or soft deletion over immediate permanent deletion.
- Relationships must not cause hard deletion cascades that silently remove unrelated content.
- Version block payloads so editors and migrations can evolve safely. **TBD — block payload persistence and versioning strategy.**
- Audit or history support may be added later.
- Sync metadata and conflict representation require a future decision.
- Platform-specific layout records remain separate from shared content; their future synchronization policy is unresolved.

See [architecture](architecture.md) and [editor and content blocks](editor-and-content-blocks.md).
