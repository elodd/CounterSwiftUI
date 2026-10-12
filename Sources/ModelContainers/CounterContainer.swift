//
//  CounterContainer.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-08-09.
//

import Foundation
import SwiftData

actor CounterContainer {
    static let prefilledExamplesKey = "prefilledExamples"

    @MainActor
    static public func createContainer(
        inMemory: Bool = false,
        userDefaults: UserDefaults = .standard
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
