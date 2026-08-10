# Desktop UI

## Shell

The desktop shell uses a traditional menu bar, optional context-aware toolbar, persistent Project Explorer, draggable divider, large work area, and bottom status bar. The work area receives most of the window.

```text
┌────────────────────────────────────────────────────────────────┐
│ File  Edit  Projects  Tools  Help                              │
├────────────────────────────────────────────────────────────────┤
│ Context-aware toolbar                                          │
├────────────────────┬───────────────────────────────────────────┤
│ Project Explorer   │ Work Area                                 │
│ Workspace tree     │ Selected content                          │
├────────────────────┴───────────────────────────────────────────┤
│ Status and contextual information                              │
└────────────────────────────────────────────────────────────────┘
```

## Project Explorer

The explorer is always available in the desktop layout, resizable, and placeable on either side. Its side and width persist. The implemented developer tree renders the persisted `Workspace → Project → App → optional Idea Group → Idea` hierarchy with staggered indentation and subtle parent, sibling-continuation, and last-child connector lines. Ungrouped Ideas appear under an `Ungrouped` node when present. Workspace, Project, App, Idea Group, and Ungrouped nodes expand or collapse in presentation state; Idea selection reveals and focuses the matching container in the work area. Arrow keys navigate or expand the tree, Enter activates a row, and accessible expand/collapse labels accompany visible focus and selection states. Contextual actions should eventually include create, rename, move, duplicate, archive, and properties.

“Always available” does not require the explorer to consume permanent screen space at every width. Narrow layouts may collapse, overlay, or temporarily hide it, but a predictable visible control or keyboard action must restore it immediately. The explorer must never become permanently unavailable.

## Menus

- **File:** New, Open, Save, Save All, Import, Export, Recent, Settings, Exit.
- **Edit:** Undo, Redo, Cut, Copy, Paste, Select All, Find, Find in Project, Replace.
- **Projects:** New Workspace, Project, App, Idea Group, or Idea; Rename, Move, Duplicate, Archive, Properties, Import, Export.
- **Tools:** future Command Palette, Templates, shortcut editor, Integrations, Extensions, maintenance, and diagnostics.
- **Help:** Getting started, Documentation, Keyboard shortcuts, Report a problem, Check for updates, About devGarden.

Commands may be context-sensitive but remain predictable. Settings initially belongs under File and may use a familiar shortcut.

## Toolbar

Global candidates are New…, Save, Undo, Redo, Search, and zoom controls. New… adapts to context and may offer hierarchy items or Idea, Flowchart, Snippet, Document, and Task.

Contextual text-editing controls may include:

- Bold
- Italic
- Underline, if supported
- Heading level
- Bulleted and numbered lists
- Checklist
- Code block
- Quote
- Font controls, if supported
- Text-size controls
- Block insertion

These controls must appear or become enabled only when they are relevant to the active content. Toolbar customization is future scope.

## Idea pinboard

The implemented App and Idea Group Ideas view is a vertically stacked, single-scroll workspace. Multiple Ideas may be expanded simultaneously; each expanded container hosts the existing block editor, while collapse retains a compact title and updated-time header without discarding content or editor-session history. New Idea capture expands and focuses its initial Paragraph immediately. Search and Explorer selection reveal the matching Idea, and a focused single-Idea route remains available. Collapse state is presentation-only and is not stored in domain tables.

This stacked workspace is an incremental daily-use surface, not the future pinboard. It has no freeform coordinates, floating windows, resize handles, z-order, snapping, or always-on-top behavior. Planned pinboard actions remain move, resize, bring to front, collapse to the title bar, restore, minimize or collapse without losing content, maximize within the work area, focused edit, duplicate, move, and archive.

Pinning or “always on top” applies only inside the devGarden work area. It may keep an Idea above other contained Idea windows, but must never place it above unrelated operating-system windows.

Planned layout tools include saved positions and sizes, auto arrange, cascade, horizontal or vertical tile, fit all, reset, optional snap/grid/alignment guides, and pinned-only filtering. Pinboard layout is presentation state separate from Idea content.

## Status bar

Use sensible regions for Ready, contextual help, Saving/Saved, Loading, Searching, Importing, Exporting, future Sync/Offline, errors, and progress. Optional Caps Lock, Num Lock, and Scroll Lock indicators are desktop-only. Avoid crowding.

## Adaptation and customization

- **Wide:** full explorer and toolbar; multiple Idea windows where useful.
- **Medium:** narrower explorer and condensed toolbar; clear icons may replace labels.
- **Narrow/portrait desktop:** explorer may collapse, overlay, or hide temporarily; contextual controls reorganize and the work area stays primary.

Dark is the default theme, not the only theme. Planned customization includes:

- Dark, light, and system themes
- Font family
- Editor font
- Code font
- Font sizes
- UI scale
- Compact or comfortable density
- Accent colour
- Icon size
- Explorer placement and width
- Toolbar layout
- Visible status-bar sections
- Default landing context
- Default Idea view
- Slash-command suggestions
- Markdown conversion preferences
- Keyboard shortcuts
- Mobile toolbar
- Swipe actions
- Motion preferences

Use minimal monochrome icons where practical and motion only for state or orientation. Platform-specific preferences must remain separate from shared content.

See [mobile UI](mobile-ui.md) and [keyboard and input](keyboard-and-input.md).
