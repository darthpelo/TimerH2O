//
//  Presenter.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 29/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import Foundation

struct Presenter {
    fileprivate weak var view: ViewProtocol?
    fileprivate var healthManager: HealthManager
    fileprivate var sessionManager: SessionManager
    fileprivate var dataManager: DataWrapper
    
    init(view: ViewProtocol? = nil,
         healthManager: HealthManager = HealthManager(),
         sessionManager: SessionManager = SessionManagerImplementation(),
         dataManager: DataWrapper = RealmManager()) {
        self.view = view
        self.healthManager = healthManager
        self.sessionManager = sessionManager
        self.dataManager = dataManager
    }
    
    func setupView() {
        if sessionIsStarted() {
            if let timeInterval = sessionManager.endTimer()?.timeIntervalSince(Date()), timeInterval > 0 {
                startTimer(timeInterval)
            } else {
                endInterval()
                DispatchQueue.main.async {
                    self.view?.showWaterPicker()
                }
            }
        }
        
        view?.setAmountLabel(with: "\(sessionManager.amountOfWater())")
    }
    
    func save(_ water: Int, _ interval: TimeInterval) {
        let model = Model(idx: UUID().uuidString, water: Double(water), interval: interval)
        sessionManager.new(sessioId: model.idx)
        sessionManager.newAmountOf(water: Double(water))
        sessionManager.newTimeInterval(second: interval)
        dataManager.create(newSession: model)
        
        WatchManager.sharedInstance.set(goal: water)
        updateWatch()
    }
    
    func startSession() {
        AnswerManager().log(event: "StartSessoin")
        sessionManager.newSession(isStart: true)
        self.view?.startButton(isEnabled: false)
        self.view?.stopTimerButton(isEnabled: true)
        self.view?.endSessionButton(isEnabled: true)
    }
    
    func stopSession() {
        AnswerManager().log(event: "StopSession")
        
        modelUpdate()
        
        sessionManager.newSession(isStart: false)
        sessionManager.newAmountOf(water: 0)
        endInterval()
        stopTimer()
        
        WatchManager.sharedInstance.set(goal: 0)
        updateWatch()
        
        self.view?.startButton(isEnabled: true)
        self.view?.stopTimerButton(isEnabled: false)
        self.view?.endSessionButton(isEnabled: false)
        self.view?.setTimerLabel(with: R.string.localizable.timerviewTimerLabelFinish_presenter())
    }
    
    func sessionIsStarted() -> Bool {
        switch sessionManager.state() {
        case .start:
            return true
        case .end:
            return false
        }
    }
    
    func intervalIsStarted() -> Bool {
        switch sessionManager.intervalState() {
        case .start:
            return true
        case .end:
            return false
        }
    }
    
    func startTimer() {
        TimerManager.sharedInstance.start()
        
        let endTime = Date(timeIntervalSinceNow: sessionManager.timeInterval())
        sessionManager.new(endTimer: endTime)
        sessionManager.new(countDown: sessionManager.timeInterval())
        
        TimerManager.sharedInstance.scheduledTimer = {
            self.updateCountDown()
        }
    }
    
    func startTimer(_ endTimer: TimeInterval) {
        sessionManager.new(countDown: endTimer)
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
        sessionManager.newInterval(isStart: true)
        startTimer()
        view?.setTimerLabel(with: sessionManager.timeInterval().toString())
    }
    
    func endInterval() {
        AnswerManager().log(event: "EndInterval")
        sessionManager.newInterval(isStart: false)
        sessionManager.new(endTimer: Date(timeIntervalSince1970: 1))
        sessionManager.new(countDown: 0)
        TimerManager.sharedInstance.stop()
    }
    
    func update(water amount: Double) {
        var actualAmount = sessionManager.amountOfWater()
        
        actualAmount -= amount
        sessionManager.newAmountOf(water: actualAmount)
        
        if actualAmount > 0 {
            startInterval()
        } else {
            stopSession()
        }
        
        updateAmountLabel(actualAmount)
        
        saveToHealthKit(newAmount: amount)
    }
    
    func updateWatch() {
        WatchManager.sharedInstance.update(water: sessionManager.amountOfWater(),
                                           countDown: sessionManager.countDown())
    }
    
    // MARK: - Private
    private func modelUpdate() {
        dataManager.updateSession(withEnd: Date(), finalAmount: sessionManager.amountOfWater())
    }
    
    private func updateCountDown() {
        let countDown = sessionManager.countDown() - 1
        sessionManager.new(countDown: countDown)
        self.view?.update(countDown: countDown,
                          amount: sessionManager.amountOfWater())
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
        healthManager.saveWaterSample(water/1000, startDate: Date(), endDate: Date())
    }
}
