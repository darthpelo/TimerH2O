//
//  TimerTests.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 04/11/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import XCTest
@testable import TimerH2O

class TimerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStartTimer() {
        let expec = expectation(description: "Waiting")
        
        TimerManager.sharedInstance.start()
        
        TimerManager.sharedInstance.scheduledTimer = {
            TimerManager.sharedInstance.stop()
            
            expec.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
