//
//  CounterSwiftUIApp.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-02-08.
//

import AppIntents
import SwiftData
import SwiftUI

@main
struct CounterSwiftUIApp: App {
    private let modelContainer: ModelContainer

    init() {
        let modelContainer = CounterContainer.createContainer(
            arguments: ProcessInfo.processInfo.arguments
        )
        self.modelContainer = modelContainer
        // Lets the counter entity query read the same store as the UI.
        AppDependencyManager.shared.add(dependency: modelContainer)
        CounterShortcuts.updateAppShortcutParameters()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(self.modelContainer)
    }
}
