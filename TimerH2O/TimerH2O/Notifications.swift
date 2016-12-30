//
//  Notifications.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 06/11/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import Foundation
import UserNotifications

enum Snooze: Double {
    case Five = 300.0
    case Fifteen = 900.0
    case Thirty = 1800.0
}

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
        let snooze5 = UNNotificationAction(identifier: TH2OConstants.UserNotification.snooze5Action,
                                          title: NSLocalizedString("usernotification.snooze.5", comment: ""),
                                          options: [.destructive])
        let snooze15 = UNNotificationAction(identifier: TH2OConstants.UserNotification.snooze15Action,
                                           title: NSLocalizedString("usernotification.snooze.15", comment: ""),
                                           options: [.destructive])
        let snooze30 = UNNotificationAction(identifier: TH2OConstants.UserNotification.snooze30Action,
                                           title: NSLocalizedString("usernotification.snooze.30", comment: ""),
                                           options: [.destructive])
        let category = UNNotificationCategory(identifier: TH2OConstants.UserNotification.timerCategory,
                                              actions: [drink, snooze5, snooze15, snooze30],
                                              intentIdentifiers: [],
                                              options: [])

        UNUserNotificationCenter.current().setNotificationCategories([category])
    } else {
        // Fallback on earlier versions
    }
}

func localNotificationRequest(snooze: Snooze? = nil, endTime: Date? = nil) {
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
        let value = triggerTime(snooze, endTime)
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: value, repeats: false)
        
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

private func triggerTime(_ snooze: Snooze?, _ endTime: Date?) -> TimeInterval {
    guard let endTime = endTime else {
        return (snooze?.rawValue)!
    }
    
    return endTime.timeIntervalSince(Date())
}
