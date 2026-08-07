# Desktop UI

## Shell

The desktop shell uses a traditional menu bar, optional context-aware toolbar, persistent Project Explorer, draggable divider, large work area, and bottom status bar. The work area receives most of the window.

```text
┌───────────────────────────────────────────────────────────┐
│ File  Edit  Projects  Tools  Help                    │
├───────────────────────────────────────────────────────────┤
│ Context-aware toolbar                                │
├──────────────────┬─────────────────────────────────────────┤
│ Project Explorer  │ Work Area                       │
│ Workspace tree    │ Selected content                │
├──────────────────┴───────────────────────────────────────────────────────────┤
│ Status and contextual information                    │
└───────────────────────────────────────────────────────────┘
```

## Project Explorer

The explorer is always available in the desktop layout, resizable, and placeable on either side. Its side and width persist. It uses familiar tree expand/collapse and keyboard interactions for `Workspace → Project → App → optional Idea Group → Idea`. Contextual actions should eventually include create, rename, move, duplicate, archive, and properties.

## Menus

- **File:** New, Open, Save, Save All, Import, Export, Recent, Settings, Exit.
- **Edit:** Undo, Redo, Cut, Copy, Paste, Select All, Find, Find in Project, Replace.
- **Projects:** New Workspace, Project, App, Idea Group, or Idea; Rename, Move, Duplicate, Archive, Properties, Import, Export.
- **Tools:** future Command Palette, Templates, shortcut editor, Integrations, Extensions, maintenance, and diagnostics.
- **Help:** Getting started, Documentation, Keyboard shortcuts, Report a problem, Check for updates, About devGarden.

Commands may be context-sensitive but remain predictable. Settings initially belongs under File and may use a familiar shortcut.

## Toolbar

Global candidates are New…, Save, Undo, Redo, Search, and zoom controls. New… adapts to context and may offer hierarchy items or Idea, Flowchart, Snippet, Document, and Task. Editing controls such as emphasis, headings, lists, checklist, code, quote, text size, and block insertion appear or enable only when relevant. Toolbar customization is future scope.

## Idea pinboard

An App or Idea Group Ideas view supports contained internal windows or cards. They never float above unrelated operating-system windows. Planned actions include move, resize, front, internal pinning, collapse/restore, maximize within the work area, focused edit, duplicate, move, and archive.

Planned layout tools include saved positions and sizes, auto arrange, cascade, horizontal or vertical tile, fit all, reset, optional snap/grid/alignment guides, and pinned-only filtering. Pinboard layout is presentation state separate from Idea content.

## Status bar

Use sensible regions for Ready, contextual help, Saving/Saved, Loading, Searching, Importing, Exporting, future Sync/Offline, errors, and progress. Optional Caps Lock, Num Lock, and Scroll Lock indicators are desktop-only. Avoid crowding.

## Adaptation and customization

- **Wide:** full explorer and toolbar; multiple Idea windows where useful.
- **Medium:** narrower explorer and condensed toolbar; clear icons may replace labels.
- **Narrow/portrait desktop:** explorer may collapse, overlay, or hide temporarily; contextual controls reorganize and the work area stays primary.

Dark is the default theme, not the only theme. Plan for system/light themes, fonts, scale, density, accent, icon size, explorer placement and width, toolbar/status configuration, editor preferences, shortcuts, and motion preferences. Use minimal monochrome icons where practical and motion only for state or orientation.

See [mobile UI](mobile-ui.md) and [keyboard and input](keyboard-and-input.md).
