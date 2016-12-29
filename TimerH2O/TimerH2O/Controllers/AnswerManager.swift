//
//  AnswerManager.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 29/12/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import Foundation
import Crashlytics

struct AnswerManager {
    func log(event eventName: String, withCustomAttributes customAttributes: [String : Any]? = nil) {
         Answers.logCustomEvent(withName: eventName, customAttributes: customAttributes)
    }
    
}
