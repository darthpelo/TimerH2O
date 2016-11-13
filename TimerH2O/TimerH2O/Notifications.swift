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
    } else {
        // Fallback on earlier versions
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
