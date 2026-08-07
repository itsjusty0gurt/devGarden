# ADR 0001 — Application technology stack

## Status

Accepted

## Date

2026-08-06

## Context

devGarden is intended to be one product across desktop and mobile, with shared content and business rules but platform-adapted presentation. The first implementation target is Windows desktop, and Android is the next planned platform. The product requires adaptive layouts, resizable panes, custom desktop pinboard interactions, keyboard-first desktop behaviour, touch-friendly mobile behaviour, rich block editing, future Flowcharts, and extensive theme and font customization.

The initial stack must support sharing domain and application logic without forcing mobile to reproduce desktop interaction patterns or turning desktop into a stretched phone interface. Local-first reliability is a core requirement.

## Decision

devGarden will use:

- **Application framework:** Flutter
- **Primary language:** Dart
- **Initial platform:** Windows desktop
- **Planned next platform:** Android
- **Potential future platforms:** iOS, Linux, and macOS; Web only if later product requirements justify it
- **State management:** Riverpod
- **Route-based navigation:** GoRouter
- **Local database technology:** SQLite

The exact Dart SQLite package, ORM, or query layer is **TBD — requires architectural decision before implementation.** This decision selects SQLite as the database technology only.

Flutter is selected because devGarden is one cross-platform product with platform-adapted presentation. Desktop and mobile should share domain models, core application logic, persistence abstractions, shared content structures, validation rules, search and synchronization concepts, and business rules. They may differ substantially in navigation, layout, pinboard behaviour, panel placement, window management, toolbar and status presentation, editing surfaces, and interaction density.

The implementation will separate at least these responsibilities:

1. Domain models
2. Application services and use cases
3. Persistence repositories
4. Presentation state
5. Platform-specific UI
6. Shared reusable UI components

This responsibility list is not a final folder structure.

Riverpod will expose application and presentation state. State organization should remain modular, business rules must not live directly in widgets, and Riverpod does not replace domain or repository boundaries.

GoRouter will handle top-level route-based navigation. Desktop pinboard windows do not need to be represented entirely as routes; internal workspace state may remain local presentation state where appropriate.

Persistence will be accessed through abstractions or repository interfaces. UI widgets must not directly own persistence logic, and the eventual synchronization layer must not be tightly coupled to widgets.

SQLite schema and persistence design must support stable identifiers, explicit ordering, created and updated timestamps, soft deletion or Trash, versioned content blocks, future synchronization metadata, future conflict handling, and platform-specific layout data stored separately from shared content.

Domain models and shared Idea content must not contain desktop-only pinboard coordinates or depend on platform presentation state. Desktop and mobile presentation state remain separate where their interaction models differ.

## Alternatives considered

### Python and PySide6

**Advantages:** Excellent Windows desktop development, strong desktop UI control, and a familiar, productive Python ecosystem.

**Disadvantages:** Mobile would likely require a separate or weaker UI strategy, increasing the risk that desktop and mobile become separate products. It is less attractive when mobile is a first-class architectural concern.

**Conclusion:** Not selected because mobile is already part of the product vision.

### React and TypeScript with Electron

**Advantages:** Large ecosystem, strong web-editor ecosystem, and flexible UI development.

**Disadvantages:** Desktop carries a browser-runtime model, mobile still requires another strategy, and implementation may diverge across platforms.

**Conclusion:** Not selected as the primary architecture.

### React Native and React Native Windows

**Advantages:** Strong JavaScript and TypeScript ecosystem, good Android and iOS support, and available Windows support.

**Disadvantages:** Windows introduces additional platform complexity, desktop-first behaviour may require more native-specific work, and the desired desktop workspace model becomes more complex.

**Conclusion:** Not selected.

### Native Windows UI and a separate mobile application

Examples include WPF, WinUI, .NET MAUI with separate compromises, and other native desktop approaches.

**Advantages:** Strong Windows integration and familiar desktop controls.

**Disadvantages:** A separate mobile presentation implementation is likely, with more duplicated effort and higher long-term maintenance cost.

**Conclusion:** Not selected.

### PWA or browser-first architecture

**Advantages:** Easy deployment, broad reach, and shared web code.

**Disadvantages:** Desktop pinboard behaviour, filesystem interaction, keyboard conventions, offline behaviour, and native desktop expectations may be constrained. It is less suitable for the intended desktop-tool experience.

**Conclusion:** Not selected as the primary application architecture.

## Consequences

### Positive

- Windows and Android share one application framework.
- Flutter supports strong custom and adaptive UI work.
- Dart is the primary application language across platforms.
- Domain and application logic can be shared more easily.
- Future Linux and macOS support remains realistic.
- Desktop and mobile can share content without sharing inappropriate layouts.

### Negative and risks

- Dart becomes a required project language.
- Advanced editor and diagram capabilities require careful package evaluation.
- Some desktop integrations may require platform-specific plugins or native code.
- Flutter package quality and Windows support must be reviewed.
- Complex block editing may require custom implementation work.

Flutter is not assumed to eliminate platform-specific work or package risk.

## Follow-up decisions

The following remain **TBD — requires architectural decision before implementation:**

- Exact Dart SQLite package, ORM, or query layer
- Rich block-editor framework or custom implementation strategy
- Desktop pinboard implementation
- Flowchart library or implementation
- Search indexing strategy
- Synchronization architecture and conflict handling
- Authentication and cloud provider, if any
- Packaging, distribution, update, and app-store strategy
- Import and export implementation details
- Telemetry, crash reporting, licensing, collaboration, encryption, and privacy policies

Provider organization and the complete route tree should be designed only when implementation requirements justify them.

## Principle alignment

- **Adaptive, not merely responsive:** Flutter is used to create distinct presentations suited to available space and platform interaction patterns.
- **Capture first:** shared application and persistence boundaries must support immediate, reliable Idea capture without required metadata.
- **Familiar over clever:** Windows must retain keyboard-first desktop conventions while Android uses touch-appropriate navigation.
- **Work with developer tools:** the architecture preserves developer-friendly import and export as a requirement without prematurely selecting its implementation.
- **Shared content, separate presentation:** platform-specific layout and pinboard state never become dependencies of shared Idea content.
