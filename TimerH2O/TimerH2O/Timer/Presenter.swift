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
    }
    
    func startSession() {
        AnswerManager().log(event: "StartSessoin")
        SessionManager().newSession(isStart: true)
        self.view?.startButton(isEbable: false)
    }
    
    func stopSession() {
        AnswerManager().log(event: "StopSession")
        
        RealmManager().updateSession(withEnd: Date(), finalAmount: SessionManager().amountOfWater())
        
        SessionManager().newSession(isStart: false)
        SessionManager().newAmountOf(water: 0)
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
        SessionManager().newAmountOf(water: actualAmount)
        if actualAmount > 0 {
            startInterval()
        } else {
            stopSession()
            self.view?.startButton(isEbable: true)
            self.view?.setTimerLabel(with: NSLocalizedString("timerview.timer.label.finish_presenter", comment: ""))
        }
        
        updateAmountLabel(actualAmount)
    }
    
    //MARK: - Private
    private func updateCountDown() {
        let countDown = SessionManager().countDown() - 1
        SessionManager().new(countDown: countDown)
        self.view?.update(countDown: countDown,
                          amount: SessionManager().amountOfWater())
    }
    
    private func updateAmountLabel(_ actualAmount: Double) {
        self.view?.setAmountLabel(with: String(amount(actualAmount)))
    }
    
    private func amount(_ level: Double) -> Double {
        return level > 0 ? level : 0
    }
}

extension Presenter {
    func healthKitIsAuthorized() -> Bool {
        guard let healthManager = healthManager else {
            return false
        }
        return healthManager.isAuthorized()
    }
    
    func healthKitAuthorize(completion: @escaping ((_ success: Bool) -> Void)) {
        guard let healthManager = healthManager else {
            completion(false)
            return
        }
        
        healthManager.authorizeHealthKit { (authorized, error) in
            if authorized {
                print("HealthKit authorization received.")
                return completion(authorized)
            } else {
                print("HealthKit authorization denied!")
                if error != nil {
                    print("\(error)")
                }
                return completion(authorized)
            }
        }
    }
    
//    fileprivate func saveToHealthKit(_ session: Session) {
//        
//    }
}
