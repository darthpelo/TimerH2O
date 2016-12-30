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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.sharedSDK().debug = true
        Fabric.with([Crashlytics.self])

        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        TimerManager.sharedInstance.stop()
        scheduleLocalNotification(endtime: SessionManager().endTimer()!)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [TH2OConstants.UserNotification.notificationRequest])
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        AnswerManager().log(event: "Application Was Killed", withCustomAttributes: ["VC":"AppDelegate", "Function":"applicationWillTerminate"])
        SessionManager().application(isKilled: true)
        TimerManager.sharedInstance.stop()
        scheduleLocalNotification(endtime: SessionManager().endTimer()!)
    }
    
    
}

extension AppDelegate {
    fileprivate func scheduleLocalNotification(endtime: Date) {
        // Create Notification Content
        if #available(iOS 10.0, *) {
            // Time interval
            let timeInterval = endtime.timeIntervalSince(Date())
            if timeInterval >= 0 {
                localNotificationRequest(endTime: endtime)
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
