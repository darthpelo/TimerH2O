//
//  Session.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 01/01/17.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import RealmSwift

class Session: Object {
    dynamic var idx = "0"
    dynamic var start = Date(timeIntervalSince1970: 1)
    dynamic var end = Date(timeIntervalSince1970: 1)
    dynamic var goal: Double = 0
    dynamic var amount: Double = 0
    dynamic var interval: TimeInterval = 0
    dynamic var user: Person?
    
    override static func primaryKey() -> String? {
        return "idx"
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
