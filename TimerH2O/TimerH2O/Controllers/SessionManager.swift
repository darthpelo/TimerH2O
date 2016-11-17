//
//  SessionManager.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 24/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import Foundation

enum StorageKey: String {
    case amountOfWater = "com.alessioroberto.amountOfWater"
    case sessionStart = "com.alessioroberto.sessionStart"
    case timeInterval =  "com.alessioroberto.timeInterval"
    case countDown = "com.alessioroberto.countDown"
}

struct SessionManager {
    func newSession(isStart: Bool) {
        UserDefaults.standard.set(isStart, forKey: StorageKey.sessionStart.rawValue)
    }
    
    func sessionStart() -> Bool {
        return UserDefaults.standard.bool(forKey: StorageKey.sessionStart.rawValue)
    }
    
    func newAmountOf(water: Double) {
        UserDefaults.standard.set(water, forKey: StorageKey.amountOfWater.rawValue)
    }
    
    func amountOfWater() -> Double {
        return UserDefaults.standard.double(forKey: StorageKey.amountOfWater.rawValue)
    }
    
    func newTimeInterval(second: TimeInterval) {
        UserDefaults.standard.set(second, forKey: StorageKey.timeInterval.rawValue)
    }
    
    func timeInterval() -> TimeInterval {
        return UserDefaults.standard.double(forKey: StorageKey.timeInterval.rawValue)
    }
    
    func new(countDown: TimeInterval) {
        UserDefaults.standard.set(countDown, forKey: StorageKey.countDown.rawValue)
    }
    
    func countDown() -> TimeInterval {
        return UserDefaults.standard.double(forKey: StorageKey.countDown.rawValue)
    }
}
