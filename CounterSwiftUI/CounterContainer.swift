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
    @AppStorage("prefilledCounters") static var prefilledCounters: Bool = false
    @MainActor
    static public func createContainer() -> ModelContainer {
        let schema = Schema([CounterModel.self])
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: configuration)
        if prefilledCounters == false {
            CounterModel.defaults.forEach { container.mainContext.insert($0) }
            prefilledCounters = true
        }
        return container
    }
}
