//
//  Notifications.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 06/11/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import Foundation
import UserNotifications

func notificationsSettings() {
    // Request Notification Settings
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                })
            case .denied:
                print("Application Not Allowed to Display Notifications")
            default:()
            }
        }
        let drink = UNNotificationAction(identifier: TH2OConstants.UserNotification.drinkAction,
                                         title: NSLocalizedString("usernotification.drink", comment: ""),
                                         options: [.authenticationRequired, .foreground])
        let snooze = UNNotificationAction(identifier: TH2OConstants.UserNotification.snoozeAction,
                                          title: NSLocalizedString("usernotification.snooze", comment: ""),
                                          options: [.destructive])
        let category = UNNotificationCategory(identifier: TH2OConstants.UserNotification.timerCategory,
                                              actions: [drink, snooze],
                                              intentIdentifiers: [],
                                              options: [])

        UNUserNotificationCenter.current().setNotificationCategories([category])
    } else {
        // Fallback on earlier versions
    }
}

func localNotificationRequest(endTime: Date? = nil) {
    if #available(iOS 10.0, *) {
        
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "TimerH2O"
        //            notificationContent.subtitle = NSLocalizedString("localnotification.subtitle", comment: "")
        notificationContent.body = NSLocalizedString("localnotification.subtitle", comment: "")
        notificationContent.sound = UNNotificationSound.default()
        notificationContent.badge = 1
        notificationContent.categoryIdentifier = TH2OConstants.UserNotification.timerCategory
        
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerTime(endTime), repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: TH2OConstants.UserNotification.notificationRequest,
                                                        content: notificationContent,
                                                        trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
}

//MARK: - Private
private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
    // Request Authorization
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            
            completionHandler(success)
        }
    } else {
        // Fallback on earlier versions
    }
}

private func triggerTime(_ endTime: Date?) -> TimeInterval {
    guard let endTime = endTime else {
        return 120
    }
    
    return endTime.timeIntervalSince(Date())
}
