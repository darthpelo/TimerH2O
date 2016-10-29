//
//  TimerH2OTests.swift
//  TimerH2OTests
//
//  Created by Alessio Roberto on 23/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import XCTest
@testable import TimerH2O

class TimerH2OTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAmountConverter() {
        let str = ["0", "3", "0"]
        
        let result: Double = 30
        
        XCTAssertEqual(convert(amount: str), result)
    }
}
