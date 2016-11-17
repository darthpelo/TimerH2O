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
        
        SessionManager().new(countDown: SessionManager().timeInterval())
        
        TimerManager.sharedInstance.scheduledTimer = {
            let countDown = SessionManager().countDown() - 1
            self.view?.update(countDown: countDown)
            SessionManager().new(countDown: countDown)
        }
        
//        scheduleLocalNotification(timeInterval: SessionManager().timeInterval())
    }
    
    func stopSession() {
        SessionManager().newSession(isStart: false)
        TimerManager.sharedInstance.stop()
    }
}

extension Presenter {
    fileprivate func scheduleLocalNotification(timeInterval: TimeInterval) {
        // Create Notification Content
        if #available(iOS 10.0, *) {
            let notificationContent = UNMutableNotificationContent()
            
            // Configure Notification Content
            notificationContent.title = "TimerH2O"
            notificationContent.subtitle = NSLocalizedString("localnotification.subtitle", comment: "")
//            notificationContent.body = "In this tutorial, you learn how to schedule local notifications with the User Notifications framework."
            
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
        } else {
            // Fallback on earlier versions
        }
    }
}
