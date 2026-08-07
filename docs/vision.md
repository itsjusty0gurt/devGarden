# Product vision

## Identity

**devGarden**

**Where ideas grow!**

devGarden is a developer-focused workspace for capturing, organizing, connecting, planning, and developing programming ideas. It is not a full IDE. It should complement Visual Studio, VS Code, GitHub, Codex, other coding assistants, and normal developer files.

The first user is an individual developer. The architecture should not prevent later collaboration, but collaboration is not part of the first desktop MVP.

## Desired outcome

A developer can capture a thought immediately, develop it with mixed content, find it later even if it was never carefully organized, and connect it to the project context where it matters. Desktop and mobile share content while using layouts suited to each platform.

## Organizational model

`Workspace → Project → App → optional Idea Group → Idea`

- **Workspace:** a broad boundary such as Personal, Work, Client, or Open Source.
- **Project:** a major product, initiative, product family, or development effort.
- **App:** an application, component, library, service, module, or major development area.
- **Idea Group:** an optional grouping within an App.
- **Idea:** the primary object for capturing and developing a thought.

Every App permits ungrouped Ideas. If no suitable App is active, capture must save safely to an Inbox or another clearly defined unorganized location. The hierarchy names describe product concepts, not necessarily physical folders.

## Content by context

- A **Workspace** offers details, Projects, Inbox, Recent, Pinned, Archived, and settings.
- A **Project** offers an overview, Apps, Documents, Vision, Architecture, AI rules, UI guidelines, Data model, Roadmap, Decisions, files, and settings. Document templates must remain extensible rather than hardcoded.
- An **App** offers Ideas, Flowcharts, Snippets, Documents, Tasks, Files, Groups, and settings.
- An **Idea Group** filters relevant Ideas, Flowcharts, Snippets, Tasks, and Documents.
- An **Idea** opens an editable block workspace.

## Product boundaries

Confirmed requirements are described in the linked documents. Future features are staged in the [roadmap](roadmap.md), not commitments to implement them now. Technology, storage, synchronization, and framework choices remain [architectural decisions](architecture.md).

## Visual identity direction

Branding should be subtle and professional. A future icon may use a simplified tree or broadleaf plant that is recognizable at small sizes, works in monochrome, suggests branching or growth, and avoids excessive detail or cartoon styling. It should work as an application icon, toolbar mark, and mobile icon. Final logo assets are not part of Milestone 0.

See [product principles](product-principles.md), [desktop UI](desktop-ui.md), and [mobile UI](mobile-ui.md).
