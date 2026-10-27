//
//  CounterSwiftUIApp.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-02-08.
//

import SwiftData
import SwiftUI

@main
struct CounterSwiftUIApp: App {
    private let modelContainer = CounterContainer.createContainer(
        arguments: ProcessInfo.processInfo.arguments
    )

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(self.modelContainer)
    }
}
