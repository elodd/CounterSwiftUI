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

enum CounterIntentError: Error, CustomLocalizedStringResourceConvertible {
    case notFound

    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .notFound: "That counter no longer exists."
        }
    }
}

/// What the voice intents do, with the same view model and save as the detail screen.
@MainActor
enum CounterActions {
    static func counter(id: String, in context: ModelContext) throws -> CounterModel {
        let descriptor = FetchDescriptor<CounterModel>(predicate: #Predicate { $0.id == id })
        guard let counterModel = try context.fetch(descriptor).first else {
            throw CounterIntentError.notFound
        }
        return counterModel
    }

    static func increment(id: String, in context: ModelContext) async throws -> CounterModel {
        let viewModel = CounterViewModel(counterModel: try self.counter(id: id, in: context))
        await viewModel.increment()
        try viewModel.save(in: context)
        return viewModel.counterModel
    }

    static func decrement(id: String, in context: ModelContext) async throws -> CounterModel {
        let viewModel = CounterViewModel(counterModel: try self.counter(id: id, in: context))
        await viewModel.decrement()
        try viewModel.save(in: context)
        return viewModel.counterModel
    }
}

struct IncrementCounterIntent: AppIntent {
    static let title: LocalizedStringResource = "Increment Counter"
    static let description = IntentDescription("Adds one to a counter without opening the app.")

    @Parameter(title: "Counter")
    var counter: CounterEntity

    @Dependency private var modelContainer: ModelContainer

    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<Int> & ProvidesDialog {
        let counterModel = try await CounterActions.increment(id: self.counter.id, in: self.modelContainer.mainContext)
        return .result(value: counterModel.count, dialog: "\(counterModel.name) is now \(counterModel.count).")
    }
}

struct DecrementCounterIntent: AppIntent {
    static let title: LocalizedStringResource = "Decrement Counter"
    static let description = IntentDescription("Subtracts one from a counter without opening the app.")

    @Parameter(title: "Counter")
    var counter: CounterEntity

    @Dependency private var modelContainer: ModelContainer

    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<Int> & ProvidesDialog {
        let counterModel = try await CounterActions.decrement(id: self.counter.id, in: self.modelContainer.mainContext)
        return .result(value: counterModel.count, dialog: "\(counterModel.name) is now \(counterModel.count).")
    }
}

struct GetCountIntent: AppIntent {
    static let title: LocalizedStringResource = "Get Count"
    static let description = IntentDescription("Tells the current count of a counter.")

    @Parameter(title: "Counter")
    var counter: CounterEntity

    @Dependency private var modelContainer: ModelContainer

    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<Int> & ProvidesDialog {
        let counterModel = try CounterActions.counter(id: self.counter.id, in: self.modelContainer.mainContext)
        return .result(value: counterModel.count, dialog: "\(counterModel.name) is at \(counterModel.count).")
    }
}

struct CounterShortcuts: AppShortcutsProvider {
    // No Siri phrases for `OpenCounterIntent`: it needs an unlocked device to open the app.
    // It stays available as an action in the Shortcuts app.
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: IncrementCounterIntent(),
            phrases: [
                "Increment \(\.$counter) in \(.applicationName)",
                "Add one to \(\.$counter) in \(.applicationName)"
            ],
            shortTitle: "Increment Counter",
            systemImageName: "plus.circle"
        )
        AppShortcut(
            intent: DecrementCounterIntent(),
            phrases: [
                "Decrement \(\.$counter) in \(.applicationName)",
                "Subtract one from \(\.$counter) in \(.applicationName)"
            ],
            shortTitle: "Decrement Counter",
            systemImageName: "minus.circle"
        )
        AppShortcut(
            intent: GetCountIntent(),
            phrases: [
                "What's \(\.$counter) in \(.applicationName)",
                "Get the count of \(\.$counter) in \(.applicationName)"
            ],
            shortTitle: "Get Count",
            systemImageName: "number.circle"
        )
    }
}
