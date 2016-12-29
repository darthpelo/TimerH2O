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
        SessionManager().newSession(isStart: true)
    }
    
    func stopSession() {
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
            let countDown = SessionManager().countDown() - 1
            let amount = SessionManager().amountOfWater()
            self.view?.update(countDown: countDown, amount: amount)
            SessionManager().new(countDown: countDown)
        }
    }
    func stopTimer() {
        TimerManager.sharedInstance.stop()
    }
    
    func startInterval() {
        SessionManager().newInterval(isStart: true)
        startTimer()
    }
    
    func endInterval() {
        SessionManager().newInterval(isStart: false)
        TimerManager.sharedInstance.stop()
    }
    
    func startTimer(_ endTimer: TimeInterval) {
        SessionManager().new(countDown: endTimer)
        TimerManager.sharedInstance.start()
        
        TimerManager.sharedInstance.scheduledTimer = {
            let countDown = SessionManager().countDown() - 1
            let amount = SessionManager().amountOfWater()
            self.view?.update(countDown: countDown, amount: amount)
            SessionManager().new(countDown: countDown)
        }
    }
    
    func update(water amount: Double) {
        var actualAmount = SessionManager().amountOfWater()
        actualAmount -= amount
        if actualAmount > 0 {
            SessionManager().newAmountOf(water: actualAmount)
            self.view?.setAmountLabel(with: actualAmount.toString())
            startInterval()
        } else {
            stopSession()
            self.view?.setTimerLabel(with: NSLocalizedString("timerview.timer.label.finish_presenter", comment: ""))
        }
    }
    
    func startLocalNotification() {
        scheduleLocalNotification(endtime: SessionManager().endTimer()!)
    }
    
}

extension Presenter {
    fileprivate func scheduleLocalNotification(endtime: Date) {
        // Create Notification Content
        if #available(iOS 10.0, *) {
            // Time interval
            let timeInterval = endtime.timeIntervalSince(Date())
            if timeInterval >= 0 {
                let notificationContent = UNMutableNotificationContent()
                
                // Configure Notification Content
                notificationContent.title = "TimerH2O"
                //            notificationContent.subtitle = NSLocalizedString("localnotification.subtitle", comment: "")
                notificationContent.body = NSLocalizedString("localnotification.subtitle", comment: "")
                notificationContent.sound = UNNotificationSound.default()
                notificationContent.badge = 1
                
                // Add Trigger
                let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
                
                // Create Notification Request
                let notificationRequest = UNNotificationRequest(identifier: TH2OConstants.UserNotification.notificationRequest, content: notificationContent, trigger: notificationTrigger)
                
                // Add Request to User Notification Center
                UNUserNotificationCenter.current().add(notificationRequest) { (error) in
                    if let error = error {
                        print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
