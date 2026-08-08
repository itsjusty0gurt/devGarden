# Conceptual data model

This document describes the broader conceptual model and the smaller implemented schema. SQLite with Drift is accepted for local relational persistence by [ADR 0001](decisions/0001-application-technology-stack.md) and [ADR 0002](decisions/0002-local-persistence-with-drift.md). UUID v7 is accepted as the stable identifier format by [ADR 0003](decisions/0003-stable-identifiers-with-uuid-v7.md). Domain models do not depend directly on Drift-generated table or data classes.

## Implemented schema version 3

The current vertical slice persists:

- Workspace: `id`, `name`, `createdAt`, `updatedAt`, `sortOrder`, `isDeleted`
- Project: `id`, `workspaceId`, `name`, `createdAt`, `updatedAt`, `sortOrder`, `isDeleted`
- App: `id`, `projectId`, `name`, `createdAt`, `updatedAt`, `sortOrder`, `isDeleted`
- Idea Group: `id`, `appId`, `name`, `createdAt`, `updatedAt`, `sortOrder`, `isDeleted`
- Idea: `id`, `appId`, nullable `groupId`, `title`, legacy compatibility `body`, `lifecycle`, `createdAt`, `updatedAt`, `sortOrder`, `isPinned`, `isDeleted`
- Content Block: `id`, `ideaId`, `type`, `sortOrder`, `textContent`, `metadataJson`, `payloadVersion`, `createdAt`, `updatedAt`, `isDeleted`

IDs and foreign IDs use canonical UUID v7 strings stored as SQLite `TEXT`. The domain wraps them in `EntityId`, so application logic does not depend on that storage representation. Foreign keys preserve the hierarchy without destructive cascades. The version 1 to version 2 migration creates Idea Groups and adds nullable membership. The version 2 to version 3 migration creates Content Blocks and converts each non-empty legacy Idea body into one Paragraph block with a new UUID v7 while preserving the complete Idea record. Empty bodies do not produce meaningless persisted blocks during migration. New-editor behavior creates an empty Paragraph only when needed to make an opened Idea immediately writable.

Content Blocks are canonical Idea content after migration. `textContent` keeps editable and searchable text directly queryable. `metadataJson` stores only small type-specific values: Heading level, Code language, and Checklist checked state. `payloadVersion` is currently `1`. The retained Idea `body` column is compatibility data and is not maintained as a second editable source of truth. Archiving a group is a transaction that soft-deletes the group and ungroups its active Ideas; it never deletes Ideas or blocks.

Every other conceptual entity below remains unimplemented. The future full schema, future block payload evolution, import identity, backup and recovery, and synchronization metadata remain **TBD — requires architectural decision before implementation.**

## Hierarchy and ownership

`Workspace → Project → App → optional Idea Group → Idea`

An Idea belongs to an App but may omit an Idea Group. Workspace, Project, App, and Idea Group are product concepts, not necessarily filesystem directories.

## Identifier convention

For persisted domain entities requiring durable identity, `id` means **UUID v7 stable identifier**. Foreign identifiers such as `workspace id`, `project id`, `app id`, and relationship source or target IDs conceptually reference those stable UUIDs. SQLite row IDs and Drift-generated identities are not canonical domain identity.

IDs are generated locally before persistence when necessary. Renaming, editing, or moving an object does not change its ID; duplicating an object normally creates a new UUID. Import identity and collision handling remain **TBD — requires architectural decision before implementation.**

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

The implemented Idea-owned form is `id`, `idea id`, `block type`, `sort order`, directly queryable text, small versioned metadata, `created timestamp`, `updated timestamp`, and soft-deletion state. Implemented types are Paragraph, Heading, Code, Checklist, Bulleted List, Numbered List, Quote, and Divider. Document ownership and future block types remain deferred.

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

- Use application-generated UUID v7 stable identifiers for persisted domain objects requiring durable identity.
- Do not rely on SQLite auto-increment integers as externally meaningful, exported, or sync-capable identity.
- Use explicit sort order; timestamps alone do not define order.
- Keep created and updated timestamps as explicit metadata; do not derive them from UUID v7.
- Prefer Trash or soft deletion over immediate permanent deletion.
- Relationships must not cause hard deletion cascades that silently remove unrelated content.
- Version block payloads so editors and migrations can evolve safely. Initial Idea blocks use payload version `1`; future payload evolution remains **TBD — requires architectural decision before implementation.**
- Audit or history support may be added later.
- Sync metadata and conflict representation require a future decision.
- Platform-specific layout records remain separate from shared content; their future synchronization policy is unresolved.

See [architecture](architecture.md) and [editor and content blocks](editor-and-content-blocks.md).
