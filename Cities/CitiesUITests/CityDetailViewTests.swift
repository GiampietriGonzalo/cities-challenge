//
//  CityDetailViewTests.swift
//  CitiesUITests
//
//  Created by Gonza Giampietri on 13/06/2025.
//

import XCTest

// Test excluded: For some reason is not taking the accessibility identifier correctly
final class CityDetailUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["-UITestMode"]
        app.launch()
    }
    
    func testCityDetailsLoadCorrectly() {
        let detailButton = app.buttons.firstMatch
        XCTAssertTrue(detailButton.waitForExistence(timeout: 5))
        detailButton.tap()
    
        let content = app.otherElements["ContentView"]
        XCTAssertTrue(content.waitForExistence(timeout: 3))

        let subtitle = content.staticTexts["Subtitle"]
        XCTAssertTrue(subtitle.exists)

        let description = content.staticTexts["Description"]
        XCTAssertTrue(description.exists)

        let extract = content.staticTexts["Extract"]
        XCTAssertTrue(extract.exists)
    }
    
    func testCityDetailsErrorState() {
        app.launchArguments = ["-UITestMode", "ErrorView"]
        app.launch()
        
        let errorView = app.otherElements["ErrorView"]
        XCTAssertTrue(errorView.waitForExistence(timeout: 5))
    }
}
