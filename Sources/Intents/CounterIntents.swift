//
//  CounterIntents.swift
//  CounterSwiftUI
//
//  Created by eloddobos on 2026-10-27.
//

import AppIntents
import SwiftData

/// A counter as Siri, Shortcuts and Spotlight see it.
struct CounterEntity: AppEntity {
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Counter"
    static let defaultQuery = CounterEntityQuery()

    let id: String
    let name: String
    let count: Int

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(self.name)", subtitle: "\(self.count)")
    }

    init(_ counterModel: CounterModel) {
        self.id = counterModel.id
        self.name = counterModel.name
        self.count = counterModel.count
    }

    /// Counters sorted by name, optionally filtered.
    @MainActor
    static func all(in context: ModelContext, where predicate: Predicate<CounterModel>? = nil) throws -> [CounterEntity] {
        let descriptor = FetchDescriptor(predicate: predicate, sortBy: [SortDescriptor(\.name)])
        return try context.fetch(descriptor).map(CounterEntity.init)
    }
}

struct CounterEntityQuery: EntityStringQuery {
    @Dependency private var modelContainer: ModelContainer

    @MainActor
    func entities(for identifiers: [String]) async throws -> [CounterEntity] {
        try CounterEntity.all(in: self.modelContainer.mainContext, where: #Predicate { identifiers.contains($0.id) })
    }

    @MainActor
    func entities(matching string: String) async throws -> [CounterEntity] {
        try CounterEntity.all(in: self.modelContainer.mainContext, where: #Predicate { $0.name.localizedStandardContains(string) })
    }

    @MainActor
    func suggestedEntities() async throws -> [CounterEntity] {
        try CounterEntity.all(in: self.modelContainer.mainContext)
    }
}

/// Opens a counter through the existing `counterswiftui://counter/<id>` deep link.
struct OpenCounterIntent: AppIntent {
    static let title: LocalizedStringResource = "Open Counter"
    static let description = IntentDescription("Opens a counter in the app.")

    @Parameter(title: "Counter")
    var counter: CounterEntity

    func perform() async throws -> some IntentResult & OpensIntent {
        .result(opensIntent: OpenURLIntent(CounterModel.deepLinkURL(id: self.counter.id)))
    }
}

struct CounterShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: OpenCounterIntent(),
            phrases: [
                "Open \(\.$counter) in \(.applicationName)",
                "Show \(\.$counter) in \(.applicationName)"
            ],
            shortTitle: "Open Counter",
            systemImageName: "number"
        )
    }
}
