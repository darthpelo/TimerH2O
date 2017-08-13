//
//  PresenterTests.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 12/08/2017.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import XCTest
import RealmSwift

@testable import TimerH2O

class PresenterTests: XCTestCase {
    fileprivate var mockUserDefaults = MockUserDefaults()
    fileprivate var sessionMananger: MockSessionManager?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.sessionMananger = MockSessionManager(userDefault: mockUserDefaults)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    private func createSUT() -> Presenter {
        return Presenter(view: nil,
                         healthManager: HealthManager(),
                         sessionManager: sessionMananger!,
                         dataManager: MockDataWrapper()
        )
        
    }
    func testSaveSession() {
        let sut = createSUT()
        
        sut.save(0, 0)
        XCTAssertEqual(self.sessionMananger!.amountOfWater(), 0)
    }
    
    func testStartSession() {
        let sut = createSUT()
        
        sut.startSession()
        XCTAssertEqual(State.start, self.sessionMananger!.state())
    }
    
    func testStopSession() {
        let sut = createSUT()
        
        sut.stopSession()
        XCTAssertEqual(State.end, self.sessionMananger!.state())
    }
    
    func testSartTimer() {
        let sut = createSUT()
        
        sut.startTimer()
        XCTAssertEqual(0, self.sessionMananger!.timeInterval())
        
        sut.startTimer(0)
        XCTAssertEqual(nil, self.sessionMananger!.endTimer())
    }
    
    func testSTartInterval() {
        let sut = createSUT()
        
        sut.startInterval()
        XCTAssertEqual(State.start, self.sessionMananger!.intervalState())
    }
    
    func testUpdateWater() {
        let sut = createSUT()
        
        sut.update(water: 0)
        XCTAssertEqual(self.sessionMananger!.amountOfWater(), 0)
    }
    
    
}

private extension XCTestCase {
    struct MockSessionManager: SessionManager {
        private var userDefault: MockUserDefaults
        
        init(userDefault: MockUserDefaults) {
            self.userDefault = userDefault
        }
        
        func newSession(isStart: Bool) {
            userDefault.set(isStart, forKey: StorageKey.sessionStart.rawValue)
        }
        
        func state() -> State {
            if userDefault.bool(forKey: StorageKey.sessionStart.rawValue) == true {
                return .start
            } else {
                return .end
            }
        }
        func intervalState() -> State {
            if userDefault.bool(forKey: StorageKey.intervalStart.rawValue) == true {
                return .start
            } else {
                return .end
            }
        }
        func newInterval(isStart: Bool) {
            userDefault.set(isStart, forKey: StorageKey.intervalStart.rawValue)
        }
        func amountOfWater() -> Double { return 0 }
        func new(sessioId: String) {}
        func newAmountOf(water: Double) {}
        func newTimeInterval(second: TimeInterval) {}
        func endTimer() -> Date? { return nil }
        func timeInterval() -> TimeInterval { return 0 }
        func new(countDown: TimeInterval) {}
        func countDown() -> TimeInterval { return 0 }
        func new(endTimer: Date) {}
    }
    
    struct MockDataWrapper: DataWrapper {
        func create(newUser userId: String) {}
        func create(newSession session: Model) {}
        func updateSession(withEnd end: Date, finalAmount amount: Double) {}
        func update(session: Session, withUser user: Person) {}
        func loadAllSessions() -> Results<Session>? { return nil }
        func loadSession(withId idx: String) -> Session? { return nil }
        func loadUser(withId userId: String) -> Person? { return nil }
    }
    
    class MockUserDefaults: UserDefaults {
        
        private var dictionary: [String: Any] = [:]
        
        override func set(_ value: Bool, forKey defaultName: String) {
            dictionary[defaultName] = value
        }
        
        override func bool(forKey defaultName: String) -> Bool {
            guard let value: Bool = dictionary[defaultName] as? Bool else {
                return false
            }
            
            return value
        }
    }
}
