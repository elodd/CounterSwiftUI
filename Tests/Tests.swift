//
//  Tests.swift
//  Tests
//
//  Created by eloddobos on 2025-08-07.
//

import XCTest
import CounterSwiftUI

final class Tests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

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
