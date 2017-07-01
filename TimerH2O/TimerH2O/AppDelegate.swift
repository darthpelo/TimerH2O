//
//  AppDelegate.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 23/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var watcher = WatchManager()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.sharedSDK().debug = true
        Fabric.with([Crashlytics.self])
        
        if UserDefaults.standard.userCreated == false {
            if let userId = UIDevice.current.identifierForVendor?.uuidString {
                RealmManager().create(newUser: userId)
                UserDefaults.standard.userCreated = true
                UserDefaults.standard.synchronize()
            }
        }
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        TimerManager.sharedInstance.stop()
        scheduleLocalNotification(SessionManager().endTimer())
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [TH2OConstants.UserNotification.notificationRequest])
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        AnswerManager().log(event: "Application Was Killed",
                            withCustomAttributes: ["VC":
                                "AppDelegate", "Function":
                                "applicationWillTerminate"])
        TimerManager.sharedInstance.stop()
        scheduleLocalNotification(SessionManager().endTimer())
    }
    
}

extension AppDelegate {
    fileprivate func scheduleLocalNotification(_ endTime: Date?) {
        guard let endTime = endTime else {
            return
        }
        // Create Notification Content
        if #available(iOS 10.0, *) {
            // Time interval
            let timeInterval = endTime.timeIntervalSince(Date())
            if timeInterval >= 0 {
                localNotificationRequest(endTime: endTime)
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
