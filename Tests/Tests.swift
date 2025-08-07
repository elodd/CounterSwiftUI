//
//  Tests.swift
//  Tests
//
//  Created by eloddobos on 2025-08-07.
//

import XCTest
import CounterSwiftUI

final class Tests: XCTestCase {

    func testCounterIncrement() throws {
        let counterModel = CounterModel(name: "Test Counter")
        let viewModel = CounterViewModel(counterModel: counterModel)
        viewModel.increment()
        viewModel.increment()
        viewModel.increment()
        viewModel.increment()
        viewModel.decrement()
        XCTAssertEqual(viewModel.counterModel.count, 3, "Counter should increment by 3")
    }

    func testCounterDateString() throws {
        let counterModel = CounterModel(name: "Test Counter")
        let dateString = counterModel.dateString()
        XCTAssertFalse(dateString.isEmpty, "Date string should not be empty")
    }

    func testCounterNameString() throws {
        let counterModel = CounterModel(name: "Test Counter")
        let nameString = counterModel.nameString()
        XCTAssertEqual(nameString, "Name: Test Counter", "Name string should match the counter name")
    }

    func testCounterCountString() throws {
        let counterModel = CounterModel(name: "Test Counter", count: 5)
        let countString = counterModel.countString()
        XCTAssertEqual(countString, "Count: 5", "Count string should match the counter count")
    }
}
