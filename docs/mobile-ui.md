# Mobile UI

Mobile shares the content model but uses a mobile-appropriate flow. It must not shrink the desktop pinboard onto a phone.

```text
┌───────────────────────────────────┐
│ ☰ Menu                       New…  │
├───────────────────────────────────┤
│ Current project-tree location ▼   │
├───────────────────────────────────┤
│ Ideas                              │
│ Flowcharts                         │
│ Snippets                           │
│ Documents                          │
│ Tasks                              │
│ Files                              │
└───────────────────────────────────┘
```

- **Menu** opens broader navigation and application actions.
- **New…** offers creation actions appropriate to the current context.
- **Current location** shows and changes the selected Workspace, Project, App, or Idea Group through the hierarchy.
- **Main content** shows categories appropriate to that level.

Workspace choices may include Projects, Inbox, Recent, Pinned, and Archived. Project choices may include Apps, Documents, Architecture, AI Rules, Roadmap, Flowcharts, and Files. App choices may include Ideas, Flowcharts, Snippets, Documents, Tasks, Files, and Groups.

The navigation sequence is: choose location → choose content type → choose or create item → open focused editor.

Ideas normally use lists, compact lists, cards, or status boards. Editing is full-screen. Complex Flowchart editing may be deferred, but mobile must eventually view, navigate, and open linked content, with basic editing planned.

## Capture and offline behaviour

New Idea is a one-tap priority: immediately open and focus a large editor, show the software keyboard, require no metadata, and permit saving. The active App may be the default destination; otherwise use a safe Inbox or defined unorganized location.

Mobile must eventually create and edit offline, persist safely on-device, reopen without loss, and synchronize later without silently discarding conflicts. Synchronization details remain [open architectural decisions](architecture.md).

## Adaptation

Tablet landscape may use a narrow persistent explorer beside content. Tablet portrait may use an explorer drawer. Phone uses the top controls, location selector, content list, and focused editors without desktop floating windows.

Do not use a permanent desktop status bar. Show compact states such as Saving…, Saved, Searching…, Offline — saved locally, and Sync complete. Mobile toolbar layout, swipe actions, and motion preferences are future customization.

See [desktop UI](desktop-ui.md) and [editor and content blocks](editor-and-content-blocks.md).
