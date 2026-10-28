//
//  CounterViewModel.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2025-02-08.
//

import SwiftData
import SwiftUI

/// What `CounterViewModel.save(in:)` needs from a context: `ModelContext` in the app, a mock in tests.
protocol ContextSaver {
    func save() throws
}

extension ModelContext: ContextSaver {}

@MainActor
@Observable
final class CounterViewModel {
    var counterModel: CounterModel

    var name: String {
        counterModel.name
    }

    init(counterModel: CounterModel) {
        self.counterModel = counterModel
    }

    func countString() -> String {
        "\(String(localized: "countLabelTitle")) \(self.counterModel.count)"
    }

    func nameString() -> String {
        "\(String(localized: "nameLabelTitle")) \(self.counterModel.name)"
    }

    func dateString() -> String {
        let dateFormat = self.counterModel.date.formatted(date: .numeric, time: .shortened)
        return "\(String(localized: "dateLabelTitle")) \(dateFormat)"
    }

    func increment() async {
        self.counterModel.count += 1
    }

    func decrement() async {
        self.counterModel.count -= 1
    }

    func updateDate() {
        self.counterModel.date = Date()
    }

    func save(in context: some ContextSaver) throws {
        self.updateDate()
        try context.save()
    }
}
