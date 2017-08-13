//
//  LocalDataTests.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 27/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import XCTest

@testable import TimerH2O

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
        SessionManagerImplementation().newSession(isStart: true)
        XCTAssertEqual(State.start, SessionManagerImplementation().state())
        SessionManagerImplementation().newSession(isStart: false)
        XCTAssertEqual(State.end, SessionManagerImplementation().state())
    }

    func testWaterSetupTests() {
        let water = 50.0
        SessionManagerImplementation().newAmountOf(water: water)
        XCTAssertEqual(SessionManagerImplementation().amountOfWater(), water)
    }

    func testTimeIntervalTests() {
        let timer: Double = 15 // Second
        SessionManagerImplementation().newTimeInterval(second: timer)
        XCTAssertEqual(SessionManagerImplementation().timeInterval(), timer)
    }

    func testSaveDate() {
        let date = Date()
        SessionManagerImplementation().new(endTimer: date)
        
        let result = SessionManagerImplementation().endTimer()
        XCTAssertNotNil(result)
        XCTAssertEqual(result, date)
    }

}
