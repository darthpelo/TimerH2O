//
//  Presenter.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 29/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import Foundation
import UserNotifications

struct Presenter {
    weak var view: ViewProtocol?
    
    func save(model: Model) {
        SessionManager().newAmountOf(water: Double(model.water))
        SessionManager().newTimeInterval(second: model.interval)
    }
    
    func startSession() {
        AnswerManager().log(event: "StartSessoin")
        SessionManager().newSession(isStart: true)
    }
    
    func stopSession() {
        AnswerManager().log(event: "StopSession")
        SessionManager().newSession(isStart: false)
        endInterval()
        stopTimer()
    }
    
    func startTimer() {
        TimerManager.sharedInstance.start()
        
        let endTime = Date(timeIntervalSinceNow: SessionManager().timeInterval())
        SessionManager().new(endTimer: endTime)
        SessionManager().new(countDown: SessionManager().timeInterval())
        
        TimerManager.sharedInstance.scheduledTimer = {
            self.updateCountDown()
        }
    }
    func stopTimer() {
        TimerManager.sharedInstance.stop()
    }
    
    func startInterval() {
        AnswerManager().log(event: "StartInterval")
        SessionManager().newInterval(isStart: true)
        startTimer()
    }
    
    func endInterval() {
        AnswerManager().log(event: "EndInterval")
        SessionManager().newInterval(isStart: false)
        TimerManager.sharedInstance.stop()
    }
    
    func startTimer(_ endTimer: TimeInterval) {
        SessionManager().new(countDown: endTimer)
        TimerManager.sharedInstance.start()
        
        TimerManager.sharedInstance.scheduledTimer = {
            self.updateCountDown()
        }
    }
    
    func update(water amount: Double) {
        var actualAmount = SessionManager().amountOfWater()
        
        actualAmount -= amount
        
        if actualAmount > 0 {
            startInterval()
        } else {
            stopSession()
            self.view?.setTimerLabel(with: NSLocalizedString("timerview.timer.label.finish_presenter", comment: ""))
        }
        
        updateAmountLabel(actualAmount)
    }
    
    private func updateCountDown() {
        let countDown = SessionManager().countDown() - 1
        SessionManager().new(countDown: countDown)
        self.view?.update(countDown: countDown,
                          amount: SessionManager().amountOfWater())
    }
    
    private func updateAmountLabel(_ actualAmount: Double) {
        SessionManager().newAmountOf(water: amount(actualAmount))
        self.view?.setAmountLabel(with: String(amount(actualAmount)))
    }
    
    private func amount(_ level: Double) -> Double {
        return level > 0 ? level : 0
    }
}
