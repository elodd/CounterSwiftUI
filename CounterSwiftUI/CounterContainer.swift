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
    @AppStorage("isAddedToContainer") static var isAddedToContainer: Bool = false
    @MainActor
    static public func createContainer() -> ModelContainer {
        let schema = Schema([CounterModel.self])
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: configuration)
        if isAddedToContainer == false {
            CounterModel.defaults.forEach { model in
                container.mainContext.insert(model)
            }
            isAddedToContainer = true
        }
        return container
    }
}
