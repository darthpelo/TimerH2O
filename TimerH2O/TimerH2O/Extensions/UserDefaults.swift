//
//  UserDefaults.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 11/06/2017.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import Foundation

extension UserDefaults {
    var userCreated: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
}
