//
//  unitTests.swift
//  unitTests
//
//  Created by eloddobos on 2025-08-07.
//

import Foundation
import SwiftData
import Testing
@testable import CounterSwiftUI

// MARK: - CounterModel

@Suite("CounterModel")
struct CounterModelTests {

    @Test func initDefaults() {
        let before = Date()
        let model = CounterModel(name: "Test Counter")
        let after = Date()

        #expect(model.name == "Test Counter")
        #expect(model.count == 0)
        #expect(!model.id.isEmpty)
        #expect((before...after).contains(model.date))
    }

    @Test func initCustomValues() {
        let date = Date(timeIntervalSince1970: 1_000_000)
        let model = CounterModel(name: "Custom", count: 42, date: date)

        #expect(model.count == 42)
        #expect(model.date == date)
    }

    @Test func idsAreUnique() {
        let ids = Set((0..<100).map { _ in CounterModel(name: "x").id })
        #expect(ids.count == 100)
    }

    @Test func defaults() {
        let counterTitle = String(localized: "counterTitle")
        let defaults = CounterModel.defaults

        #expect(defaults.map(\.name) == ["\(counterTitle)0", "\(counterTitle)1", "\(counterTitle)2"])
        #expect(defaults.map(\.count) == [0, 1, 2])
    }

    @Test func descriptionContainsFields() {
        let model = CounterModel(name: "Described", count: 7)

        #expect(model.description.contains(model.id))
        #expect(model.description.contains("name: Described"))
        #expect(model.description.contains("count: 7"))
    }
}

// MARK: - CounterViewModel

@Suite("CounterViewModel")
struct CounterViewModelTests {

    private func makeViewModel(name: String = "Test Counter", count: Int = 0) -> CounterViewModel {
        CounterViewModel(counterModel: CounterModel(name: name, count: count))
    }

    @Test func incrementAndDecrement() {
        let viewModel = makeViewModel()
        (0..<4).forEach { _ in viewModel.increment() }
        #expect(viewModel.counterModel.count == 4)

        viewModel.decrement()
        #expect(viewModel.counterModel.count == 3)
    }

    @Test func decrementBelowZero() {
        let viewModel = makeViewModel()
        viewModel.decrement()
        #expect(viewModel.counterModel.count == -1)
    }

    @Test func changesWriteThroughToModel() {
        let model = CounterModel(name: "Shared")
        CounterViewModel(counterModel: model).increment()
        #expect(model.count == 1)
    }

    @Test func nameMirrorsModel() {
        let viewModel = makeViewModel(name: "Original")
        viewModel.counterModel.name = "Renamed"
        #expect(viewModel.name == "Renamed")
    }

    @Test func updateDateMovesForward() {
        let model = CounterModel(name: "Dated", date: Date(timeIntervalSince1970: 0))
        let before = Date()

        CounterViewModel(counterModel: model).updateDate()

        #expect(model.date >= before)
    }

    @Test func nameString() {
        #expect(makeViewModel().nameString() == "Name: Test Counter")
    }

    @Test(arguments: [0, 5, -3, 1_000])
    func countString(count: Int) {
        #expect(makeViewModel(count: count).countString() == "Count: \(count)")
    }

    @Test func dateString() {
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let viewModel = CounterViewModel(counterModel: CounterModel(name: "Dated", date: date))
        let expected = "Last updated: \(date.formatted(date: .numeric, time: .shortened))"

        #expect(viewModel.dateString() == expected)
    }
}

// MARK: - SwiftData persistence

@Suite("Persistence")
@MainActor
struct CounterPersistenceTests {

    private let container: ModelContainer
    private var context: ModelContext { container.mainContext }

    init() throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: CounterModel.self, configurations: configuration)
    }

    private func fetchAll() throws -> [CounterModel] {
        try context.fetch(FetchDescriptor<CounterModel>(sortBy: [SortDescriptor(\.name)]))
    }

    @Test func insertAndFetch() throws {
        CounterModel.defaults.forEach { context.insert($0) }
        try context.save()

        let counters = try fetchAll()
        #expect(counters.count == 3)
        #expect(counters.map(\.count) == [0, 1, 2])
    }

    @Test func incrementIsPersisted() throws {
        let model = CounterModel(name: "Persisted")
        context.insert(model)
        let viewModel = CounterViewModel(counterModel: model)

        viewModel.increment()
        viewModel.increment()
        try context.save()

        let fetched = try #require(try fetchAll().first { $0.id == model.id })
        #expect(fetched.count == 2)
    }

    @Test func delete() throws {
        let keep = CounterModel(name: "A")
        let remove = CounterModel(name: "B")
        context.insert(keep)
        context.insert(remove)
        try context.save()

        context.delete(remove)
        try context.save()

        #expect(try fetchAll().map(\.name) == ["A"])
    }
}
