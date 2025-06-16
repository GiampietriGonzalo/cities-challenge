//
//  CityListViewTests.swift
//  CitiesUITests
//
//  Created by Gonza Giampietri on 16/06/2025.
//

import XCTest

final class CityListViewTests: XCTestCase {

    private var app: XCUIApplication!
    
    private var loadingView: XCUIElement {
        app.staticTexts["CityDetailLoadingView"]
    }
    
    private var potraitSearchBar: XCUIElement {
        app.textFields["PortraitSearchBar"]
    }
    
    private var landscapeSearchBar: XCUIElement {
        app.textFields["LandscapeSearchBar"]
    }
    
    private var landscapeMapView: XCUIElement {
        app.otherElements["LandscapeMapView"]
    }
    
    private var cityList: XCUIElement {
        app.scrollViews["CityList"]
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

    func testPotraitView() throws {
        XCUIDevice.shared.orientation = .portrait
        XCTAssert(cityList.waitForExistence(timeout: 2))
        XCTAssert(potraitSearchBar.exists)
        XCTAssert(!loadingView.exists)
    }
    
    func testLandscapeView() throws {
        XCUIDevice.shared.orientation = .landscapeLeft
        XCTAssert(cityList.waitForExistence(timeout: 2))
        XCTAssert(landscapeSearchBar.exists)
        XCTAssert(landscapeMapView.exists)
        XCTAssert(!potraitSearchBar.exists)
        XCTAssert(!loadingView.exists)
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
}
