//
//  SessionManager.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 24/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import Foundation

enum StorageKey: String {
    case AmountOfWater = "com.alessioroberto.amountOfWater"
    case SessionStart = "com.alessioroberto.sessionStart"
    case IntervalStart = "com.alessioroberto.intervalStart"
    case TimeInterval =  "com.alessioroberto.timeInterval"
    case CountDown = "com.alessioroberto.countDown"
    case EndTimer = "com.alessioroberto.endTimer"
    case SessionID = "com.alessioroberto.sessionid"
}

struct SessionManager {
    func newSession(isStart: Bool) {
        UserDefaults.standard.set(isStart, forKey: StorageKey.SessionStart.rawValue)
    }
    
    func sessionIsStart() -> Bool {
        return UserDefaults.standard.bool(forKey: StorageKey.SessionStart.rawValue)
    }
    
    func newInterval(isStart: Bool) {
        UserDefaults.standard.set(isStart, forKey: StorageKey.IntervalStart.rawValue)
    }
    
    func intervalIsStart() -> Bool {
        return UserDefaults.standard.bool(forKey: StorageKey.IntervalStart.rawValue)
    }
    
    func newAmountOf(water: Double) {
        UserDefaults.standard.set(water, forKey: StorageKey.AmountOfWater.rawValue)
    }
    
    func amountOfWater() -> Double {
        return UserDefaults.standard.double(forKey: StorageKey.AmountOfWater.rawValue)
    }
    
    func newTimeInterval(second: TimeInterval) {
        UserDefaults.standard.set(second, forKey: StorageKey.TimeInterval.rawValue)
    }
    
    func timeInterval() -> TimeInterval {
        return UserDefaults.standard.double(forKey: StorageKey.TimeInterval.rawValue)
    }
    
    func new(countDown: TimeInterval) {
        UserDefaults.standard.set(countDown, forKey: StorageKey.CountDown.rawValue)
    }
    
    func countDown() -> TimeInterval {
        return UserDefaults.standard.double(forKey: StorageKey.CountDown.rawValue)
    }
    
    func new(endTimer: Date) {
        UserDefaults.standard.set(endTimer, forKey: StorageKey.EndTimer.rawValue)
    }
    
    func endTimer() -> Date? {
        guard let when = UserDefaults.standard.object(forKey: StorageKey.EndTimer.rawValue) else {
            return nil
        }
        
        let date = when as? Date
        return date
    }
    
    func new(sessioId: String) {
        UserDefaults.standard.set(sessioId, forKey: StorageKey.SessionID.rawValue)
    }
    
    func sessionID() -> String? {
        return UserDefaults.standard.string(forKey: StorageKey.SessionID.rawValue)
    }
}
