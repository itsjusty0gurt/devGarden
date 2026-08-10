# Editor and content blocks

## Capture-first workflow

Creating an Idea must immediately open and focus a large writing area; mobile also opens the software keyboard. Organization and metadata are optional. Save and Save and Organize may both exist, but unorganized work must never be discarded. If an App is selected it may be the default; otherwise save to an Inbox or another clearly defined safe location.

After capture, an Idea may optionally record:

- What the Idea is
- Why it would help
- Title and hierarchy location
- Status, priority, impact, and complexity
- Dependencies, Tags, and related Ideas
- Architecture impact
- Rough UI notes
- Flowcharts
- Tasks or checklists
- Code examples
- Research notes
- Decision history

None of this information is required before a user can begin writing or save an Idea.

## Block model

Ideas now use a flexible ordered block editor with Paragraph, Heading, Code, Checklist, Bulleted List, Numbered List, Quote, and Divider blocks. Blocks have stable UUID v7 identity and explicit persisted order. Move Up and Move Down provide the initial reliable reordering mechanism; deletion is soft and never deletes the Idea or sibling blocks. If no active blocks remain, the editor creates a writable Paragraph.

Primary text is stored directly and small type-specific values use payload-versioned metadata. Heading supports H1–H3, Code stores its selected language, and Checklist stores checked state. The implementation uses focused Flutter controls rather than a large editor framework. Documents, richer block types, inline formatting spans, drag-and-drop, and export mapping remain deferred.

## Daily editing behavior

Undo and redo are block-aware within the currently open Idea. `Ctrl+Z` undoes and `Ctrl+Y` or `Ctrl+Shift+Z` redoes text bursts and structural actions including add, soft delete, type conversion, reorder, checklist state, heading level, Code language, and fenced-code conversion. Text changes are coalesced into short typing bursts rather than one history entry per character. History is bounded, belongs only to the current editor session, and is not persisted. Restoring an added or deleted block reactivates the same persistence record and UUID. Undo and redo flush or supersede pending autosave work before applying their result, then persist the resulting state.

Changing a block type replaces type-specific metadata with the new type's defaults; for example, converting away from Code and later back to Code selects Plain Text. Undoing the conversion restores the previous type and metadata because it restores the earlier block state.

Paragraph Enter splits at the cursor into two Paragraph blocks. Heading Enter splits into a Heading followed by a Paragraph. Checklist Enter splits into another Checklist; an empty Checklist exits to a Paragraph. Quote Enter creates a following Paragraph. Bulleted List, Numbered List, and Code retain normal multiline Enter behavior inside the block. `Shift+Enter` inserts a newline at the cursor inside the current Paragraph, Heading, Checklist, Bulleted List, Numbered List, Quote, or Code block without creating another block; it uses normal text history and autosave. `Ctrl+Enter` always inserts a Paragraph after the active block.

Backspace at the start of an empty editable non-Code block removes that block without affecting its Idea and focuses a nearby block. Backspace at the start of a non-empty Paragraph merges it into a preceding Paragraph when compatible. At the start of a Heading it converts the Heading to a Paragraph. Code boundaries remain explicit and are never merged into Paragraph text. Deleting the final active block immediately creates and focuses a usable Paragraph.

`Ctrl+Up` and `Ctrl+Down` focus adjacent blocks, while `Ctrl+Home` and `Ctrl+End` focus the first and last block. `Alt+Up` and `Alt+Down` persistently reorder the active block and retain its focus where practical. Add, conversion, delete, undo, and redo use stable block UUIDs to select a predictable focus target. Compact three-dot block controls expose type conversion, movement, and soft deletion; the focused block receives only a restrained active treatment. Essential controls have keyboard operation, accessible labels, and concise tooltips.

## Inline code blocks

An inline Code block is implemented inside an Idea at a specific position among other blocks. It provides editable multiline whitespace-preserving monospace text, horizontal scrolling, Tab indentation, language selection, exact clipboard Copy, brief Copied feedback, autosave, and restart persistence. The initial selector includes Plain Text, Dart, C#, Python, JavaScript, TypeScript, JSON, SQL, HTML, CSS, Bash, and PowerShell. Syntax highlighting remains deferred: the reviewed packages either add an editor/dependency surface disproportionate to this polish task or do not cover the current language and exact-editing requirements cleanly. Optional line numbers, collapse/expand, and mobile full-screen editing are also deferred.

A **Snippet** is different: it is an independently managed, reusable code object associated with a supported scope. Exact Snippet scope remains unresolved. Inline blocks must not be incorrectly promoted into global Snippets.

## Fast insertion

The visible Add Block control supports every implemented type, so slash commands are never required knowledge. Typing `/` at the start of a Paragraph opens an editor-local command menu. Further input filters the choices; Up and Down change selection, Enter applies it, Escape closes it, and pointer selection remains available. Implemented block commands are `/paragraph`, `/heading`, `/code`, `/checklist`, `/bullets`, `/numbered`, `/quote`, and `/divider`. Implemented Code aliases are `/csharp`, `/python`, `/js`, `/javascript`, `/typescript`, `/sql`, `/json`, `/html`, `/css`, and `/dart`. Entering a complete command and pressing Enter remains a keyboard-only path.

Entering a standalone triple-backtick marker in a Paragraph converts it into an editable Code block, removes the marker, and retains editing focus. A recognized language marker selects Plain Text, C#, Python, JavaScript, TypeScript, Dart, SQL, JSON, HTML, CSS, Bash, or PowerShell as applicable. The conversion participates in undo and restores the original Paragraph marker when undone. This is a focused initiation convention, not full Markdown parsing.

Block text uses debounced autosave. Switching, inserting, moving, deleting, leaving the editor, and explicit `Ctrl+S` flush relevant pending edits. Failed text remains in editor state for retry. Current App search matches Idea titles and active textual block content, ignores deleted Ideas and blocks, and remains App-wide across Idea Group filters.

The App workspace can host multiple expanded Idea editors in one outer scrolling surface. Each Idea has its own controller, dirty state, autosave queue, and session-scoped undo/redo history keyed by stable Idea UUID. Actions and undo in the focused Idea do not mutate a sibling Idea. Collapsing flushes pending changes for that Idea and removes the expanded editor surface without deleting content; reopening the container restores the same in-session controller and history. The focused `/idea/:id` editing route remains supported.

## Documents and developer files

Projects support extensible document templates such as Vision, Architecture, AI Rules, UI Guidelines, Data Model, Roadmap, Decisions, meeting notes, API documentation, changelog, and blank documents. Documents use the same or a compatible editor. Future import/export should favor normal files, particularly Markdown, with external-edit conflict awareness.

See [data model](data-model.md), [keyboard and input](keyboard-and-input.md), and [architecture](architecture.md).
