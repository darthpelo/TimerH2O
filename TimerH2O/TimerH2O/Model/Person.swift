//
//  Person.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 01/01/17.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import RealmSwift

class Person: Object {
    @objc dynamic var userId = ""
    @objc dynamic var name = ""
    @objc dynamic var birthday = NSDate(timeIntervalSince1970: 1)
    @objc dynamic var emailAddress = ""
    
    let sessions = List<Session>()
}
