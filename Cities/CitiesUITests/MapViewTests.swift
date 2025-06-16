//
//  MapViewTests.swift
//  CitiesUITests
//
//  Created by Gonza Giampietri on 16/06/2025.
//

import XCTest

final class MapViewTests: XCTestCase {
    
    private var app: XCUIApplication!
    
    private var mapView: XCUIElement {
        app.otherElements.matching(identifier: "MapView").firstMatch
    }
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchArguments = ["-UITestMode"]
        app.launch()
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testView() throws {
        app.staticTexts.matching(identifier: "CityTitle").firstMatch.tap()
        XCTAssert(mapView.waitForExistence(timeout: 0.5))
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
}
