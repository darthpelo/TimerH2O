//
//  HistoryPresenterTests.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 06/08/2017.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import XCTest
import RealmSwift

@testable import TimerH2O

class HistoryPresenterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNoHistory() {
        let dataWrapper = MockDataWrapper()
        let sut = HistoryPresenterImplementation(view: MockView(), dataWrapper: dataWrapper)
        
        XCTAssertEqual(sut.loadSessions(), 0)
        XCTAssertNil(sut.data(forCellAt: 0))
    }
}

private extension XCTestCase {
    struct MockDataWrapper: DataWrapper {
        func create(newSession session: Model) {}
        func create(newUser userId: String) {}
        func loadSession(withId idx: String) -> Session? {
            return nil
        }
        func loadUser(withId userId: String) -> Person? {
            return nil
        }
        func update(session: Session, withUser user: Person) {}
        func updateSession(withEnd end: Date, finalAmount amount: Double) {}
        func loadAllSessions() -> Results<Session>? {
            return nil
        }
    }
    
    class MockView: HistoryView {}
}
