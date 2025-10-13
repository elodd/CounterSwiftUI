//
//  unitTests.swift
//  unitTests
//
//  Created by eloddobos on 2025-08-07.
//

import XCTest
import CounterSwiftUI

final class unitTests: XCTestCase {

    func testCounterIncrement() throws {
        let counterModel = CounterModel(name: "Test Counter")
        let viewModel = CounterViewModel(counterModel: counterModel)
        viewModel.increment()
        viewModel.increment()
        viewModel.increment()
        viewModel.increment()
        XCTAssertEqual(viewModel.counterModel.count, 4, "Counter should increment by 4")
        viewModel.decrement()
        XCTAssertEqual(viewModel.counterModel.count, 3, "Counter should increment by 3")
    }

    func testCounterDateString() throws {
        let counterModel = CounterModel(name: "Test Counter")
        let viewModel = CounterViewModel(counterModel: counterModel)
        let dateString = viewModel.dateString()
        XCTAssertFalse(dateString.isEmpty, "Date string should not be empty")
    }

    func testcounterTitleString() throws {
        let counterModel = CounterModel(name: "Test Counter")
        let viewModel = CounterViewModel(counterModel: counterModel)
        let nameString = viewModel.nameString()
        XCTAssertEqual(nameString, "Name: Test Counter", "Name string should match the counter name")
    }

    func testCounterCountString() throws {
        let counterModel = CounterModel(name: "Test Counter", count: 5)
        let viewModel = CounterViewModel(counterModel: counterModel)
        let countString = viewModel.countString()
        XCTAssertEqual(countString, "Count: 5", "Count string should match the counter count")
    }
}
