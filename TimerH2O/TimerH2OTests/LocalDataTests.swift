//
//  LocalDataTests.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 27/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import XCTest

class LocalDataTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSessionInProgressTests() {
        SessionManager().newSession(isStart: true)
        XCTAssertTrue(SessionManager().sessionStart())
        SessionManager().newSession(isStart: false)
        XCTAssertFalse(SessionManager().sessionStart())
    }

    func testWaterSetupTests() {
        let water = 50.0
        SessionManager().newAmountOf(water: water)
        XCTAssertEqual(SessionManager().amountOfWater(), water)
    }

    func testTimeIntervalTests() {
        let timer: Double = 15 // Second
        SessionManager().newTimeInterval(second: timer)
        XCTAssertEqual(SessionManager().timeInterval(), timer)
    }

    func testSaveDate() {
        let date = Date()
        SessionManager().new(endTimer: date)
        
        let result = SessionManager().endTimer()
        XCTAssertNotNil(result)
        XCTAssertEqual(result, date)
    }

}
