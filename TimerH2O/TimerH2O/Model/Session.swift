//
//  Session.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 01/01/17.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import RealmSwift

class Session: Object {
    @objc dynamic var idx = "0"
    @objc dynamic var start = Date(timeIntervalSince1970: 1)
    @objc dynamic var end = Date(timeIntervalSince1970: 1)
    @objc dynamic var goal: Double = 0
    @objc dynamic var amount: Double = 0
    @objc dynamic var interval: TimeInterval = 0
    @objc dynamic var user: Person?
    
    override static func primaryKey() -> String? {
        return "idx"
    }
}
