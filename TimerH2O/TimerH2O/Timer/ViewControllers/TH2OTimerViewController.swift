//
//  TH2OTimerViewController.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 23/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit
import UserNotifications

class TH2OTimerViewController: UIViewController, Configurable, Seguible {

    @IBOutlet weak var timerLabel: UILabel!
    
    lazy var presenter: Presenter = Presenter(view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: - temporary
//        SessionManager().newSession(isStart: false)
        
        // Configure User Notification Center
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
        }
        
        setupNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        notificationsSettings()
        
        if SessionManager().sessionStart() {
            presenter.startSession()
        } else {
            newSession()
            presenter.stopSession()
        }
    }

    @IBAction func drinkButtonPressed(_ sender: AnyObject) {
    }
    
    @IBAction func unwindToTimer(segue: UIStoryboardSegue) {
        setTimerLabel(with: SessionManager().timeInterval())
    }
    
    func didEnterBackground() {
        presenter.stopTimer()
        presenter.startLocalNotification()
    }
    
    func didBecomeActive() {
        if #available(iOS 10.0, *) {
            if let timeInterval = SessionManager().endTimer()?.timeIntervalSince(Date()), timeInterval > 0 {
                    self.presenter.startTimer(timeInterval)
            } else {
                print("tempo scaduto")
                presenter.stopSession()
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [TH2OConstants.UserNotification.notificationRequest])
        }
    }
}

extension TH2OTimerViewController: ViewProtocol {
    internal func update(countDown: TimeInterval) {
        if countDown == 0 {
            presenter.stopSession()
        }
        setTimerLabel(with: countDown)
    }
}

extension TH2OTimerViewController: UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
}
