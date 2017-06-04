//
//  TimerH2OUITests.swift
//  TimerH2OUITests
//
//  Created by Alessio Roberto on 23/01/2017.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import XCTest

class TimerH2OUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSecondFoo() {
        
        let app = XCUIApplication()
        snapshot("0Home")
        let startNewDrinkSessionButton = app.buttons["start"]
        startNewDrinkSessionButton.tap()
        app.buttons["done"].tap()
        snapshot("1Session")
        app.buttons["cancel"].tap()
        startNewDrinkSessionButton.tap()
        snapshot("2StartSession")
        app.buttons["end"].tap()
        snapshot("3EndSession")
    }
    
}
