//
//  CounterContainer.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-08-09.
//

import Foundation
import SwiftData

/// Where the prefilled-examples flag lives: `UserDefaults` in the app, a mock in tests.
protocol KeyValueStore {
    func bool(forKey key: String) -> Bool
    func set(_ value: Bool, forKey key: String)
}

extension UserDefaults: KeyValueStore {}

actor CounterContainer {
    static let prefilledExamplesKey = "prefilledExamples"
    static let uiTestingArgument = "-uiTesting"
    static let uiTestingEmptyArgument = "-uiTestingEmpty"
    static let uiTestingSuiteName = "uiTesting"

    /// Uses a fresh in-memory store when launched by UI tests, prefilled with the
    /// examples unless `-uiTestingEmpty` is also passed.
    @MainActor
    static func createContainer(arguments: [String]) -> ModelContainer {
        guard arguments.contains(uiTestingArgument),
              let userDefaults = UserDefaults(suiteName: uiTestingSuiteName) else {
            return createContainer()
        }
        userDefaults.removePersistentDomain(forName: uiTestingSuiteName)
        userDefaults.set(arguments.contains(uiTestingEmptyArgument), forKey: prefilledExamplesKey)
        return createContainer(inMemory: true, userDefaults: userDefaults)
    }

    @MainActor
    static public func createContainer(
        inMemory: Bool = false,
        userDefaults: any KeyValueStore = UserDefaults.standard
    ) -> ModelContainer {
        let schema = Schema([CounterModel.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: inMemory)
        let container = try! ModelContainer(for: schema, configurations: configuration)
        if userDefaults.bool(forKey: prefilledExamplesKey) == false {
            CounterModel.defaults.forEach { container.mainContext.insert($0) }
            userDefaults.set(true, forKey: prefilledExamplesKey)
        }
        return container
    }
}
