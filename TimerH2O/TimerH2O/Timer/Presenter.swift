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
        SessionManager().newSession(isStart: true)
    }
    
    func startSession() {
        TimerManager.sharedInstance.start()
        
        let endTime = Date(timeIntervalSinceNow: SessionManager().timeInterval())
        SessionManager().new(endTimer: endTime)
        SessionManager().new(countDown: SessionManager().timeInterval())
        
        TimerManager.sharedInstance.scheduledTimer = {
            let countDown = SessionManager().countDown() - 1
            self.view?.update(countDown: countDown)
            SessionManager().new(countDown: countDown)
        }
    }
    
    func stopSession() {
        SessionManager().newSession(isStart: false)
        TimerManager.sharedInstance.stop()
    }
    
    func stopTimer() {
        TimerManager.sharedInstance.stop()
    }
    
    func startLocalNotification() {
        scheduleLocalNotification(endtime: SessionManager().endTimer()!)
    }
    
    func startTimer(_ endTimer: TimeInterval) {
        SessionManager().new(countDown: endTimer)
        TimerManager.sharedInstance.start()
        
        TimerManager.sharedInstance.scheduledTimer = {
            let countDown = SessionManager().countDown() - 1
            self.view?.update(countDown: countDown)
            SessionManager().new(countDown: countDown)
        }
    }
    
    func update(water amount: Double) {
        var actualAmount = SessionManager().amountOfWater()
        actualAmount -= amount
        if actualAmount > 0 {
            SessionManager().newAmountOf(water: actualAmount)
            startSession()
        } else {
            stopSession()
            self.view?.setTimerLabel(with: NSLocalizedString("timerview.timer.label.finish_presenter", comment: ""))
        }
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
