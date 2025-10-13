//
//  CounterContainer.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-08-09.
//

import Foundation
import SwiftData
import SwiftUI

actor CounterContainer {
    @AppStorage("prefilledExamples") static var prefilledExamples: Bool = false
    @MainActor
    static public func createContainer() throws -> ModelContainer {
        let schema = Schema([CounterModel.self])
        let configuration = ModelConfiguration()
        do {
            let container = try ModelContainer(for: schema, configurations: configuration)
            if prefilledExamples == false {
                CounterModel.defaults.forEach { container.mainContext.insert($0) }
                prefilledExamples = true
            }
            return container
        }
    }
}
