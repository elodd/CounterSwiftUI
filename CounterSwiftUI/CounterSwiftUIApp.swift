//
//  CounterSwiftUIApp.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-02-08.
//

import SwiftUI

@main
struct CounterSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(
            CounterContainer.createContainer(shouldCreateDefaults: false))
    }
}
