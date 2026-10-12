//
//  uiTests.swift
//  UITests
//
//  Created by eloddobos on 2026-10-12.
//

import XCTest

// Mirrors CounterContainer.uiTestingArgument / uiTestingEmptyArgument.
private let uiTestingArgument = "-uiTesting"
private let uiTestingEmptyArgument = "-uiTestingEmpty"

@MainActor
final class CounterUITests: XCTestCase {

    override func setUp() async throws {
        continueAfterFailure = false
    }

    // MARK: - Helpers

    private func launch(empty: Bool = false) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = [uiTestingArgument, "-AppleLanguages", "(en)", "-AppleLocale", "en_US"]
        if empty {
            app.launchArguments.append(uiTestingEmptyArgument)
        }
        app.launch()
        return app
    }

    private func rows(in app: XCUIApplication) -> XCUIElementQuery {
        app.buttons.matching(identifier: "counterRow")
    }

    private func countDisplay(in app: XCUIApplication) -> XCUIElement {
        app.staticTexts["countDisplay"]
    }

    private func assertCount(_ count: Int, in app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        let display = countDisplay(in: app)
        XCTAssertTrue(display.waitForExistence(timeout: 5), file: file, line: line)
        XCTAssertTrue(display.label.hasSuffix(" \(count)"), "label was \"\(display.label)\"", file: file, line: line)
    }

    private func goBack(in app: XCUIApplication) {
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }

    // MARK: - List

    func testLaunchShowsExampleCounters() {
        let app = launch()
        XCTAssertTrue(rows(in: app).firstMatch.waitForExistence(timeout: 5))
        XCTAssertEqual(rows(in: app).count, 3)
    }

    func testEmptyStoreShowsEmptyMessage() {
        let app = launch(empty: true)
        XCTAssertTrue(app.staticTexts["emptyViewMessage"].waitForExistence(timeout: 5))
        XCTAssertEqual(rows(in: app).count, 0)
    }

    func testAddCounterOpensDetailAndAddsRow() {
        let app = launch()
        app.buttons["addCounterButton"].tap()
        assertCount(0, in: app)

        goBack(in: app)
        XCTAssertTrue(rows(in: app).firstMatch.waitForExistence(timeout: 5))
        XCTAssertEqual(rows(in: app).count, 4)
    }

    func testAddCounterFromEmptyStore() {
        let app = launch(empty: true)
        app.buttons["addCounterButton"].tap()
        assertCount(0, in: app)

        goBack(in: app)
        XCTAssertTrue(rows(in: app).firstMatch.waitForExistence(timeout: 5))
        XCTAssertEqual(rows(in: app).count, 1)
        XCTAssertFalse(app.staticTexts["emptyViewMessage"].exists)
    }

    func testSwipeToDelete() {
        let app = launch()
        let firstRow = rows(in: app).firstMatch
        XCTAssertTrue(firstRow.waitForExistence(timeout: 5))

        firstRow.swipeLeft()
        app.buttons["Delete"].tap()

        let gone = NSPredicate(format: "count == 2")
        expectation(for: gone, evaluatedWith: rows(in: app))
        waitForExpectations(timeout: 5)
    }

    // MARK: - Detail

    func testIncrementAndDecrement() {
        let app = launch()
        rows(in: app).firstMatch.tap()
        assertCount(0, in: app)

        let increment = app.buttons["incrementButton"]
        (0..<3).forEach { _ in increment.tap() }
        assertCount(3, in: app)

        app.buttons["decrementButton"].tap()
        assertCount(2, in: app)
    }

    func testDecrementBelowZero() {
        let app = launch()
        rows(in: app).firstMatch.tap()

        app.buttons["decrementButton"].tap()
        assertCount(-1, in: app)
    }

    func testCountSurvivesNavigatingBack() {
        let app = launch()
        rows(in: app).firstMatch.tap()
        app.buttons["incrementButton"].tap()
        app.buttons["incrementButton"].tap()
        assertCount(2, in: app)

        goBack(in: app)
        rows(in: app).firstMatch.tap()
        assertCount(2, in: app)
    }
}
