//
//  AboutViewTests.swift
//  CitiesUITests
//
//  Created by Gonza Giampietri on 16/06/2025.
//

import XCTest

final class AboutViewTests: XCTestCase {

    private var app: XCUIApplication!
    
    private var contact: XCUIElement {
        app.textViews["ContactTitle"]
    }
    
    private var phone: XCUIElement {
        app.textViews["PhoneLabel"]
    }
    
    private var email: XCUIElement {
        app.textViews["EmailLabel"]
    }
    
    private var github: XCUIElement {
        app.textViews["GithubLabel"]
    }
    
    private var linkedin: XCUIElement {
        app.textViews["LandscapeMapView"]
    }
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchArguments = ["-UITestMode"]
        app.launch()
    }
    
    func testView() {
        let app = XCUIApplication()
        app.windows.first
        app.activate()
        
        XCTAssert(contact.exists)
        XCTAssert(phone.exists)
        XCTAssert(email.exists)
        XCTAssert(github.exists)
        XCTAssert(linkedin.exists)
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

}
