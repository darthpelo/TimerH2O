//
//  Constants.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 27/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import Foundation

struct TH2OConstants {
    struct UserNotification {
        static let notificationRequest = "timerh2o_local_notification"
        static let drinkAction = "com.alessioroberto.drink"
        static let snooze5Action = "com.alessioroberto.snooze.5"
        static let snooze15Action = "com.alessioroberto.snooze.15"
        static let snooze30Action = "com.alessioroberto.snooze.30"
        static let timerCategory = "com.alessioroberto.timer"
    }
    
    struct Keychain {
        static let keychainIdentifier = "com.alessioroberto.EncryptionKey"
    }
}

enum DictionaryKey: String {
    case goal
    case progress
    case countDown
    case start
    case stop
    case end
}

enum WatchText: String {
    case ok = "🏁"
    case error = "😭"
    case onGoing = "💧"
}
