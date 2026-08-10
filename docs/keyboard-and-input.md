# Keyboard and input

Important actions should support obvious controls as well as keyboard access, context menus where appropriate, slash commands, and Markdown-like input. Defaults should follow familiar Visual Studio, VS Code, Windows, and common editor conventions where practical.

## Proposed defaults

| Shortcut | Proposed action | Status |
| --- | --- | --- |
| `Ctrl+N` | New Idea or context-sensitive new item | Conflict requires a decision |
| `Ctrl+S` | Save | Proposed |
| `Ctrl+Shift+S` | Save As or a suitable save action | Applicability unresolved |
| `Ctrl+Z` / `Ctrl+Y` | Undo / Redo | Implemented in the Idea block editor |
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

The Idea block editor implements `Ctrl+S` to flush title and block changes; `Ctrl+Z`, `Ctrl+Y`, and `Ctrl+Shift+Z` for session-scoped block-aware history; `Ctrl+Enter` to insert a Paragraph after the current block; `Shift+Enter` to insert a newline inside the current text block; and `Ctrl+Shift+C` to insert a Code block. `Alt+Up` / `Alt+Down` move the active block. `Ctrl+Up` / `Ctrl+Down` focus adjacent blocks, and `Ctrl+Home` / `Ctrl+End` focus the first or last block. Code blocks intercept `Tab` for two-space indentation while Enter and `Shift+Enter` remain code newlines. In the multi-Idea workspace, undo/redo targets the Idea containing current block focus. These focused bindings do not finalize the broader customizable shortcut scheme.

Within a Paragraph, Heading, Checklist, or Quote, Enter uses the block behavior documented in [editor and content blocks](editor-and-content-blocks.md). Backspace at a block boundary is conservative: it never deletes an Idea or merges Code into normal text. Slash suggestions are keyboard-operable with Up, Down, Enter, and Escape.

All interactive surfaces require logical focus order, visible focus, keyboard activation, accessible names, and non-pointer alternatives. Context-sensitive commands should communicate current availability without becoming unpredictable.

The Project Explorer uses Up and Down to move through visible rows, Right to expand or enter children, Left to collapse or return to a parent, and Enter to activate the focused row. Tree rows expose their type and expand/collapse action semantically; these bindings work with either left or right Explorer placement.

Slash commands and Markdown-like editing are specified in [editor and content blocks](editor-and-content-blocks.md). Desktop menus and toolbar context are in [desktop UI](desktop-ui.md).
