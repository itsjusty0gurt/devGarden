# Editor and content blocks

## Capture-first workflow

Creating an Idea must immediately open and focus a large writing area; mobile also opens the software keyboard. Organization and metadata are optional. Save and Save and Organize may both exist, but unorganized work must never be discarded. If an App is selected it may be the default; otherwise save to an Inbox or another clearly defined safe location.

Potential later metadata includes title, hierarchy location, status, priority, impact, complexity, dependencies, Tags, related Ideas, architecture impact, notes, tasks, research, and decision history. None is required for initial capture.

## Block model

Ideas and Documents use a flexible, ordered block editor. Planned blocks are paragraphs, headings, code, checklists, bulleted and numbered lists, quotes, links, images, tables, Flowcharts, dividers, and a callout only if justified later. Users can freely mix them.

Block payloads require versioning and safe serialization. The editor framework and export mapping are **TBD — requires architectural decision before implementation.**

## Inline code blocks

An inline code block is embedded at a specific position in an Idea or Document. It should eventually offer editable code, syntax highlighting, language selection, copy, optional line numbers, horizontal scrolling, collapse/expand, mobile full-screen editing, and common programming/data languages.

A **Snippet** is different: it is an independently managed, reusable code object associated with a supported scope. Exact Snippet scope remains unresolved. Inline blocks must not be incorrectly promoted into global Snippets.

## Fast insertion

The editor should support visible toolbar or add-block controls, so slash commands are never required knowledge. Planned fast commands include `/code`, language aliases such as `/csharp`, `/python`, `/javascript`, `/typescript`, `/sql`, `/json`, `/html`, `/css`, and `/bash`, plus `/checklist`, `/heading`, `/quote`, and `/flowchart`. Exact aliases remain undecided.

Recognized fenced Markdown input should convert into an editable code block. Other Markdown-like conversions may be offered where predictable and configurable. Experienced users should not be forced to use a mouse.

## Documents and developer files

Projects support extensible document templates such as Vision, Architecture, AI Rules, UI Guidelines, Data Model, Roadmap, Decisions, meeting notes, API documentation, changelog, and blank documents. Documents use the same or a compatible editor. Future import/export should favor normal files, particularly Markdown, with external-edit conflict awareness.

See [data model](data-model.md), [keyboard and input](keyboard-and-input.md), and [architecture](architecture.md).
