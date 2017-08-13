//
//  SessionManager.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 24/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import Foundation

protocol SessionManager {
    func newSession(isStart: Bool)
    func state() -> State
    func intervalState() -> State
    func newInterval(isStart: Bool)
    func amountOfWater() -> Double
    func new(sessioId: String)
    func newAmountOf(water: Double)
    func newTimeInterval(second: TimeInterval)
    func endTimer() -> Date?
    func timeInterval() -> TimeInterval
    func new(countDown: TimeInterval)
    func countDown() -> TimeInterval
    func new(endTimer: Date)
}

enum StorageKey: String {
    case amountOfWater = "com.alessioroberto.amountOfWater"
    case sessionStart = "com.alessioroberto.sessionStart"
    case intervalStart = "com.alessioroberto.intervalStart"
    case timeInterval =  "com.alessioroberto.timeInterval"
    case countDown = "com.alessioroberto.countDown"
    case endTimer = "com.alessioroberto.endTimer"
    case sessionID = "com.alessioroberto.sessionid"
}

enum State {
    case start
    case end
}

struct SessionManagerImplementation: SessionManager {
    private var userDefault: UserDefaults
    
    init(userDefault: UserDefaults = UserDefaults.standard) {
        self.userDefault = userDefault
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
    
    func newSession(isStart: Bool) {
        userDefault.set(isStart, forKey: StorageKey.sessionStart.rawValue)
    }
    
    func newInterval(isStart: Bool) {
        userDefault.set(isStart, forKey: StorageKey.intervalStart.rawValue)
    }
    
    func newAmountOf(water: Double) {
        userDefault.set(water, forKey: StorageKey.amountOfWater.rawValue)
    }
    
    func amountOfWater() -> Double {
        return userDefault.double(forKey: StorageKey.amountOfWater.rawValue)
    }
    
    func newTimeInterval(second: TimeInterval) {
        userDefault.set(second, forKey: StorageKey.timeInterval.rawValue)
    }
    
    func timeInterval() -> TimeInterval {
        return userDefault.double(forKey: StorageKey.timeInterval.rawValue)
    }
    
    func new(countDown: TimeInterval) {
        userDefault.set(countDown, forKey: StorageKey.countDown.rawValue)
    }
    
    func countDown() -> TimeInterval {
        return userDefault.double(forKey: StorageKey.countDown.rawValue)
    }
    
    func new(endTimer: Date) {
        userDefault.set(endTimer, forKey: StorageKey.endTimer.rawValue)
    }
    
    func endTimer() -> Date? {
        guard let when = userDefault.object(forKey: StorageKey.endTimer.rawValue) else {
            return nil
        }
        
        let date = when as? Date
        return date
    }
    
    func new(sessioId: String) {
        userDefault.set(sessioId, forKey: StorageKey.sessionID.rawValue)
    }
    
    func sessionID() -> String? {
        return userDefault.string(forKey: StorageKey.sessionID.rawValue)
    }
}
