//
//  Presenter.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 29/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import Foundation

struct Presenter {
    weak var view: ViewProtocol?
    
    func save(model: Model) {
        SessionManager().newAmountOf(water: Double(model.water))
        SessionManager().newTimeInterval(second: model.interval)
        SessionManager().newSession(isStart: true)
    }
    
    func startSession() {
        TimerManager.sharedInstance.start()
        
        TimerManager.sharedInstance.scheduledTimer = {
            self.view?.updateCounter()
        }
    }
    
    func stopSession() {
        SessionManager().newSession(isStart: false)
        TimerManager.sharedInstance.stop()
    }
}
