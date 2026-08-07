# Roadmap

Roadmap entries describe sequencing, not authorization to implement future scope. The smallest complete slice for the active milestone takes priority.

## Milestone 0 — Documentation and architectural decisions

- Create source-of-truth documentation.
- Confirm identity, hierarchy, and desktop/mobile interaction models.
- Select a technology stack through explicit decisions.
- Record initial ADRs and repository standards.

No full application implementation belongs in this milestone.

## Milestone 1 — Local desktop foundation

- Launchable desktop shell with menu, toolbar, Project Explorer, divider, work area, and status bar.
- Default dark theme and basic settings persistence.
- Explorer left/right placement and resizing.
- Local persistence and Workspace, Project, App, and Idea Group CRUD.
- Basic validation and tests.

## Milestone 2 — Capture-first Ideas

- One-action New Idea with immediate focus.
- Safe Inbox or ungrouped saving.
- Lifecycle, priority, and impact metadata after capture.
- Searchable titles/text, Recent, and Pinned.

## Milestone 3 — Block editor

- Paragraphs, headings, lists, checklists, quotes, and dividers.
- Editable code with language selection and copy.
- Slash commands and fenced-code conversion.
- Undo/redo, autosave, and safe block serialization.

## Milestone 4 — Desktop pinboard

- Contained Idea windows with move, resize, collapse/restore, work-area maximize, pinning, and z-order.
- Saved layouts, auto arrange, tile/cascade, snap/alignment, and focused editor.

## Milestone 5 — Project Documents

- Extensible templates for Architecture, AI rules, UI guidelines, Data model, Roadmap, and Decisions.
- Markdown import/export and external-edit conflict awareness.

## Milestone 6 — Search and relationships

- Current item, App, Project, and global search.
- Code block and Snippet search, filters, context, and highlighting.
- Related Ideas, object links, and backlinks.

## Milestone 7 — Flowcharts

- Nodes, connections, labels, decision/process forms, zoom, and pan.
- Links to real Ideas and Documents; save/restore layout and basic export.

## Milestone 8 — Mobile application

- Shared content model, location selector, New… action, and category screen.
- Full-screen capture/editor, offline persistence, mobile search, editable blocks and code.
- List/card views and synchronization foundation.

## Milestone 9 — Synchronization

- Account model, device sync, offline queue, and conflict detection/preservation.
- Recovery tools and encryption/privacy review.

## Milestone 10 — Advanced integrations (future scope, not MVP)

Potential work includes Git and GitHub integrations, Codex prompt export, AI-assisted planning, collaboration, templates marketplace, extensions, public sharing, and team permissions.

## Strict first usable desktop MVP

The first MVP must let a user:

1. Launch devGarden.
2. Create a Workspace, Project, and App.
3. Optionally create an Idea Group.
4. Create an Idea immediately and type without completing metadata.
5. Save it and see it in the correct App or a safe Inbox.
6. Restart, reopen it, and search by title or text.
7. Move the Project Explorer left or right and resize it.
8. Use familiar basic keyboard shortcuts.
9. See clear save and load status.

The first MVP excludes cloud sync, accounts, collaboration, mobile release, full Flowcharts, AI, extensions, Git integration, advanced document import, complex reusable Snippets, a marketplace, and subscription features. Future features must not delay the first useful version.

## Search, Flowcharts, and future capabilities

Search is a core requirement even though its technology is unresolved. It must eventually cover titles, metadata, Idea and Document text, inline code, reusable Snippets, current context through global scope, filters, Recent/Pinned/Archived, context, and highlighting.

Flowcharts eventually support nodes, connections, labels, decisions, processes, start/end, notes, zoom/pan, and links to Ideas, Documents, Snippets, or code where practical. Activating a linked node opens the real object. Mobile must at least view, navigate, and open links; complex editing may be deferred.

See [architecture](architecture.md) for decisions that must precede implementation.
