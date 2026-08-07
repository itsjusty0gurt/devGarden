# Architecture direction

## Status

This document records constraints and decision boundaries, not a selected implementation. No technology stack is currently documented.

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

1. **Shared domain content:** hierarchy, Ideas, Documents, blocks, Flowcharts, Snippets, Tasks, Tags, and Relationships.
2. **Application behaviour:** capture, organization, lifecycle, search, import/export, and future synchronization.
3. **Platform presentation:** desktop menus, explorer, pinboard, status bar; mobile navigation, lists, and focused editors.
4. **User presentation preferences:** platform-specific layout and customization, separate from content.

These are responsibilities, not a prescribed code structure.

## Offline and synchronization direction

Local work must remain safe when disconnected. Eventual synchronization must detect conflicts and preserve both versions rather than silently overwrite work. Authentication, transport, server, merge rules, encryption, and recovery are unresolved. No cloud provider or business model is assumed.

## Open decisions

Every item below is **TBD — requires architectural decision before implementation.** Record each accepted choice in [Architectural Decision Records](decisions/README.md).

- Primary application technology stack
- Shared desktop and mobile strategy
- Local database
- Synchronization architecture
- Authentication strategy
- Cloud provider, if any
- Rich-text or block-editor framework
- Desktop pinboard implementation
- Flowchart library
- Search indexing strategy
- Import and export format
- Packaging and distribution
- App-store strategy
- Licensing
- Update mechanism
- Telemetry and crash reporting policy
- Collaboration model
- Conflict resolution
- Encryption and privacy model

## Known design tensions

The interface differences, local-first versus future cloud sync, flexible blocks versus Markdown export, customization versus consistency, and Snippets versus embedded code must be resolved without weakening the [product principles](product-principles.md). The meaning and required scope of an Inbox when no App is selected also needs a product decision.
