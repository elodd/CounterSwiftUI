//
//  CounterContainer.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-08-09.
//

import Foundation
import SwiftData

actor CounterContainer {
    /// Creates a ModelContainer for the CounterModel.

    @MainActor
    static public func createContainer(shouldCreateDefaults: Bool = true) -> ModelContainer {
        let schema = Schema([CounterModel.self])
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: configuration)
        if shouldCreateDefaults {
            CounterModel.defaults.forEach { model in
                container.mainContext.insert(model)
            }
        }
        return container
    }
}
