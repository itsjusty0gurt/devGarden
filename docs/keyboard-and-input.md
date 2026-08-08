# Keyboard and input

Important actions should support obvious controls as well as keyboard access, context menus where appropriate, slash commands, and Markdown-like input. Defaults should follow familiar Visual Studio, VS Code, Windows, and common editor conventions where practical.

## Proposed defaults

| Shortcut | Proposed action | Status |
| --- | --- | --- |
| `Ctrl+N` | New Idea or context-sensitive new item | Conflict requires a decision |
| `Ctrl+S` | Save | Proposed |
| `Ctrl+Shift+S` | Save As or a suitable save action | Applicability unresolved |
| `Ctrl+Z` / `Ctrl+Y` | Undo / Redo | Proposed |
| `Ctrl+X` / `Ctrl+C` / `Ctrl+V` | Cut / Copy / Paste | Proposed |
| `Ctrl+A` | Select All | Proposed |
| `Ctrl+F` | Find in current context | Proposed |
| `Ctrl+Shift+F` | Broader Project or Workspace search | Scope unresolved |
| `Ctrl+P` | Quick Open | Proposed |
| `Ctrl+Shift+P` | Command Palette | Proposed future tool |
| `F2` | Rename selected item | Proposed |
| `Delete` | Archive, Trash, or confirm according to context | Must never imply irreversible deletion |
| `Escape` | Cancel or close the active transient surface | Proposed |
| `Ctrl+,` | Settings | Depends on platform framework |

These are proposals, not finalized bindings. `Ctrl+N`, Save As semantics, search scope, and conflicts with editor or operating-system conventions require product decisions. Shortcuts should eventually be customizable.

The initial Idea block editor implements `Ctrl+S` to flush title and block changes, `Ctrl+Enter` to insert a Paragraph after the current block, `Ctrl+Shift+C` to insert a Code block, and `Alt+Up` / `Alt+Down` to move the current block when focus is inside it. Code blocks intercept `Tab` for two-space indentation. These focused bindings do not finalize the broader customizable shortcut scheme.

All interactive surfaces require logical focus order, visible focus, keyboard activation, accessible names, and non-pointer alternatives. Context-sensitive commands should communicate current availability without becoming unpredictable.

Slash commands and Markdown-like editing are specified in [editor and content blocks](editor-and-content-blocks.md). Desktop menus and toolbar context are in [desktop UI](desktop-ui.md).
