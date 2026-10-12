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
- Large navigation title showing the counter's name, on the grouped system background.
- The count in large bold rounded digits (120 pt, shrinks to fit) on a rounded card; it animates as it changes and turns red when negative.
- Two round buttons below: **−** (Decrement, grey) and **+** (Increment, accent colour).
- *Last updated* date and time at the bottom, with a clock icon.

## How it behaves

- **First launch:** three example counters are created — `Counter0` (0), `Counter1` (1), `Counter2` (2). This happens only once (tracked with the `prefilledExamples` key in `UserDefaults`), so deleted examples do not come back.
- **Add:** tapping **+** creates `Counter<N>` (N = the lowest number not already used, so a deleted name is reused) with count 0 and opens its detail screen.
- **Open:** tapping a row opens the counter's detail screen.
- **Increment / Decrement:** changes the count by ±1, with a light haptic tap. Counts can go below zero.
- **Save:** every count change updates *Last updated* to the current time and saves to SwiftData. Counters persist between launches.
- **Delete:** swipe left on a row to delete the counter.

## Project structure

```
Sources/
├── CounterSwiftUIApp.swift                 App entry, attaches the model container
├── Models/CounterModel.swift               @Model: id, name, count, date; example defaults, next name, delete
├── ModelContainers/CounterContainer.swift  Creates the SwiftData container, seeds examples once, UI-test launch mode
├── ViewModels/CounterViewModel.swift       @Observable: increment/decrement, save, formatted strings
├── Views/
│   ├── ContentView.swift                   List, empty state, add/delete
│   ├── CounterRowView.swift                List row
│   └── CounterDetailView.swift             Detail screen, saves on change
├── Resources/Localizable.xcstrings         UI strings (English)
├── Assets.xcassets                         App icon, accent colour
└── Preview Content/                        Assets for SwiftUI previews only
Tests/unitTests.swift                       Swift Testing: model, view model, SwiftData, container
UITests/uiTests.swift                       XCTest UI tests: list, add, delete, detail screen
project.yml                                 XcodeGen spec: app, Tests and UITests targets
.github/workflows/tests.yml                 CI: unit and UI tests on an iPhone simulator
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

Select the **CounterSwiftUI** scheme and run (⌘R). Run the tests with ⌘U; the scheme runs both test targets.

From the command line:

```sh
xcodebuild test -project CounterSwiftUI.xcodeproj -scheme CounterSwiftUI \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

### Unit tests (`Tests`)

Swift Testing. Covers the model (defaults, naming of new counters), the view model (increment/decrement, formatted strings, save), SwiftData insert/save/delete using an in-memory store, and the container's one-time example seeding.

### UI tests (`UITests`)

XCTest with `XCUIApplication` — Swift Testing is not available in UI-test targets. Covers:

- the example counters on launch, and the empty-state message
- adding a counter (from a populated and an empty list)
- swipe-to-delete
- increment/decrement on the detail screen, including below zero
- the count surviving navigation back to the list

The tests launch the app with these arguments, so they never touch the real store:

| Argument | Effect |
|---|---|
| `-uiTesting` | Fresh in-memory store with the three example counters |
| `-uiTestingEmpty` | Together with `-uiTesting`: start with no counters |

Elements are found by accessibility identifier (`addCounterButton`, `counterRow`, `countDisplay`, `incrementButton`, `decrementButton`, `emptyViewMessage`), not by localized text. The app is launched in English because the swipe-to-delete test taps the system **Delete** button.

## CI

The **Tests** workflow (`.github/workflows/tests.yml`) builds and runs the unit and UI tests on an iPhone simulator on every push to `main` and on pull requests.
