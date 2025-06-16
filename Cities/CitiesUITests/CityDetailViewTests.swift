//
//  CityDetailViewTests.swift
//  CitiesUITests
//
//  Created by Gonza Giampietri on 13/06/2025.
//

import XCTest

final class CityDetailUITests: XCTestCase {

    private var app: XCUIApplication!
        
    private var loadingView: XCUIElement {
        app.activityIndicators["CityDetailLoadingView"]
    }
    
    private var contentView: XCUIElement {
        app.staticTexts["CityDetailContentView"]
    }
    
    private var errorView: XCUIElement {
        app.staticTexts["CityDetailErrorView"]
    }

    private var subtitle: XCUIElement {
        app.staticTexts["CityDetailSubtitle"]
    }
    
    private var decription: XCUIElement {
        app.staticTexts["CityDetailDescription"]
    }
    
    private var extract: XCUIElement {
        app.staticTexts["CityDetailExtract"]
    }
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["-UITestMode"]
        app.launch()
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testCityDetailsLoadCorrectly() {
        app.buttons.matching(identifier: "CityDetailButton").firstMatch.tap()
        
        XCTAssert(subtitle.waitForExistence(timeout: 2))
        XCTAssert(decription.exists)
        XCTAssert(extract.exists)
        XCTAssert(!loadingView.exists)
    }
    
    func testCityDetailsErrorState() {
        app.buttons.matching(identifier: "CityDetailButton").element(boundBy: 1).tap()
        
        XCTAssert(errorView.waitForExistence(timeout: 2))
        XCTAssert(!contentView.exists)
        XCTAssert(!subtitle.exists)
        XCTAssert(!decription.exists)
        XCTAssert(!extract.exists)
        XCTAssert(!loadingView.exists)
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
}
