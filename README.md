# CounterSwiftUI

[![Tests](https://github.com/elodd/CounterSwiftUI/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/elodd/CounterSwiftUI/actions/workflows/tests.yml)

A small iPhone/iPad app for keeping named counters, built with SwiftUI, SwiftData and the Observation framework (`@Observable`).

## How it looks

**Counters list (main screen)**
- Navigation title **Counters**, with a **+** (Add counter) button at the top right.
- Each row shows three lines:
  ```
  Name: Counter0
  Count: 0
  Last updated: 2026-10-03 09:41
  ```
- Rows are sorted by name.
- A version label is shown in the bottom toolbar (currently the placeholder `A.B.C (build: xyz)`).
- When there are no counters, a large grey **+** icon is shown with the message *"Add a new counter by tapping the plus (+) button on the top right."*

**Counter detail**
- Navigation title is the counter's name.
- A light-blue panel (340×250 pt) with three labels:
  - 📅 Last updated: *date and time*
  - 👤 Name: *counter name*
  - ⟲ Count: *current value*
- **Decrement** and **Increment** buttons below.

## How it behaves

- **First launch:** three example counters are created — `Counter0` (0), `Counter1` (1), `Counter2` (2). This happens only once (tracked with `@AppStorage("prefilledExamples")`), so deleted examples do not come back.
- **Add:** tapping **+** creates `Counter<N>` (N = current number of counters) with count 0 and opens its detail screen.
- **Open:** tapping a row opens the counter's detail screen.
- **Increment / Decrement:** changes the count by ±1. Counts can go below zero.
- **Save:** every count change updates *Last updated* to the current time and saves to SwiftData. Counters persist between launches.
- **Delete:** swipe left on a row to delete the counter.

## Project structure

```
Sources/
├── CounterSwiftUIApp.swift                 App entry, attaches the model container
├── Models/CounterModel.swift               @Model: id, name, count, date (+ example defaults)
├── ModelContainers/CounterContainer.swift  Creates the SwiftData container, seeds examples once
├── ViewModels/CounterViewModel.swift       @Observable: increment/decrement, formatted strings
├── Views/
│   ├── ContentView.swift                   List, empty state, add/delete
│   ├── CounterRowView.swift                List row
│   └── CounterDetailView.swift             Detail screen, saves on change
└── Resources/Localizable.xcstrings         UI strings (English)
Tests/unitTests.swift                       Swift Testing: model, view model, SwiftData
project.yml                                 XcodeGen spec
```

## Requirements

- Xcode 26 or later (`CounterDetailView` uses the `#Playground` macro)
- iOS 18.2+ (iPhone and iPad)
- [XcodeGen](https://github.com/yonaskolb/XcodeGen)

## Build & test

The Xcode project is generated from `project.yml` and is not committed:

```sh
brew install xcodegen   # once
xcodegen generate
open CounterSwiftUI.xcodeproj
```

Select the **CounterSwiftUI** scheme and run (⌘R). Run the tests with ⌘U.

The tests (Swift Testing) cover the model, the view model (increment/decrement, formatted strings) and SwiftData insert/save/delete using an in-memory store.
