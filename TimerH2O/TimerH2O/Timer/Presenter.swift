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
    weak var healthManager: HealthManager?
    
    func save(_ water: Int, _ interval: TimeInterval) {
        let model = Model(idx: UUID().uuidString, water: Double(water), interval: interval)
        SessionManager().new(sessioId: model.idx)
        SessionManager().newAmountOf(water: Double(water))
        SessionManager().newTimeInterval(second: interval)
        RealmManager().create(newSession: model)
        
        WatchManager.sharedInstance.update(water: Double(water), countDown: interval)
        updateWatch()
    }
    
    func startSession() {
        AnswerManager().log(event: "StartSessoin")
        SessionManager().newSession(isStart: true)
        self.view?.startButton(isEnabled: false)
        self.view?.stopTimerButton(isEnabled: true)
        self.view?.endSessionButton(isEnabled: true)
    }
    
    func stopSession() {
        AnswerManager().log(event: "StopSession")
        
        modelUpdate()
        
        SessionManager().newSession(isStart: false)
        SessionManager().newAmountOf(water: 0)
        endInterval()
        stopTimer()
        
        updateWatch()
        
        self.view?.startButton(isEnabled: true)
        self.view?.stopTimerButton(isEnabled: false)
        self.view?.endSessionButton(isEnabled: false)
        self.view?.setTimerLabel(with: R.string.localizable.timerviewTimerLabelFinish_presenter())
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
    
    func startTimer(_ endTimer: TimeInterval) {
        SessionManager().new(countDown: endTimer)
        TimerManager.sharedInstance.start()
        
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
        SessionManager().new(endTimer: Date(timeIntervalSince1970: 1))
        SessionManager().new(countDown: 0)
        TimerManager.sharedInstance.stop()
    }
    
    func update(water amount: Double) {
        var actualAmount = SessionManager().amountOfWater()
        
        actualAmount -= amount
        SessionManager().newAmountOf(water: actualAmount)
        
        if actualAmount > 0 {
            startInterval()
        } else {
            stopSession()
        }
        
        updateAmountLabel(actualAmount)
        
        saveToHealthKit(newAmount: amount)
    }
    
    func updateWatch() {
        WatchManager.sharedInstance.update(water: SessionManager().amountOfWater(),
                                           countDown: SessionManager().countDown())
    }
    
    // MARK: - Private
    private func modelUpdate() {
        RealmManager().updateSession(withEnd: Date(), finalAmount: SessionManager().amountOfWater())
    }
    
    private func updateCountDown() {
        let countDown = SessionManager().countDown() - 1
        SessionManager().new(countDown: countDown)
        self.view?.update(countDown: countDown,
                          amount: SessionManager().amountOfWater())
        updateWatch()
    }
    
    private func updateAmountLabel(_ actualAmount: Double) {
        self.view?.setAmountLabel(with: String(amount(actualAmount)))
        updateWatch()
    }
    
    private func amount(_ level: Double) -> Double {
        return level > 0 ? level : 0
    }
}

extension Presenter {
    fileprivate func saveToHealthKit(newAmount water: Double) {
        healthManager?.saveWaterSample(water/1000, startDate: Date(), endDate: Date())
    }
}
