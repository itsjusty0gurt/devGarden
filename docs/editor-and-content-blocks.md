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

Primary text is stored directly and small type-specific values use payload-versioned metadata. Heading supports H1–H3, Code stores its selected language, and Checklist stores checked state. The implementation uses focused Flutter controls rather than a large editor framework. Documents, richer block types, inline formatting spans, drag-and-drop, undo/redo design, and export mapping remain deferred.

## Inline code blocks

An inline Code block is implemented inside an Idea at a specific position among other blocks. It provides editable multiline whitespace-preserving monospace text, horizontal scrolling, Tab indentation, language selection, exact clipboard Copy, brief Copied feedback, autosave, and restart persistence. The initial selector includes Plain Text, Dart, C#, Python, JavaScript, TypeScript, JSON, SQL, HTML, CSS, Bash, and PowerShell. Syntax highlighting, optional line numbers, collapse/expand, and mobile full-screen editing are deferred so editing reliability does not depend on a disproportionate framework.

A **Snippet** is different: it is an independently managed, reusable code object associated with a supported scope. Exact Snippet scope remains unresolved. Inline blocks must not be incorrectly promoted into global Snippets.

## Fast insertion

The visible Add Block control supports every implemented type, so slash commands are never required knowledge. Implemented block commands are `/paragraph`, `/heading`, `/code`, `/checklist`, `/bullets`, `/numbered`, `/quote`, and `/divider`. Implemented Code aliases are `/csharp`, `/python`, `/js`, `/javascript`, `/typescript`, `/sql`, `/json`, `/html`, `/css`, and `/dart`.

Entering a standalone triple-backtick marker in a Paragraph converts it into an editable Code block. A recognized language marker selects Plain Text, C#, Python, JavaScript, TypeScript, Dart, SQL, JSON, HTML, CSS, Bash, or PowerShell as applicable. This is a focused initiation convention, not full Markdown parsing.

Block text uses debounced autosave. Switching, inserting, moving, deleting, leaving the editor, and explicit `Ctrl+S` flush relevant pending edits. Failed text remains in editor state for retry. Current App search matches Idea titles and active textual block content, ignores deleted Ideas and blocks, and remains App-wide across Idea Group filters.

## Documents and developer files

Projects support extensible document templates such as Vision, Architecture, AI Rules, UI Guidelines, Data Model, Roadmap, Decisions, meeting notes, API documentation, changelog, and blank documents. Documents use the same or a compatible editor. Future import/export should favor normal files, particularly Markdown, with external-edit conflict awareness.

See [data model](data-model.md), [keyboard and input](keyboard-and-input.md), and [architecture](architecture.md).
