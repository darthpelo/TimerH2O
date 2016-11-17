//
//  TH2OTimerViewController.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 23/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit
import UserNotifications

class TH2OTimerViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    
    lazy var presenter: Presenter = Presenter(view: self)
    
    //TODO: - temporary
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SessionManager().newSession(isStart: false)
        
        // Configure User Notification Center
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(didEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        notificationCenter.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        notificationsSettings()
        
        if SessionManager().sessionStart() {
            presenter.startSession()
        } else {
            self.performSegue(withIdentifier: R.segue.tH2OTimerViewController.newSessionVC, sender: self)
            presenter.stopSession()
        }
    }

    @IBAction func drinkButtonPressed(_ sender: AnyObject) {
    }
    
    @IBAction func unwindToTimer(segue: UIStoryboardSegue) {
        timerLabel.text = "\(minutes(from: SessionManager().timeInterval()))"
    }
    
    func didEnterBackground() {
        TimerManager.sharedInstance.stop()
    }
    
    func didBecomeActive() {
//        startTimer()
    }
}

extension TH2OTimerViewController: ViewProtocol {
    internal func update(countDown: TimeInterval) {
        if countDown == 0 {
            presenter.stopSession()
        }
        
        timerLabel.text = "\(minutes(from: countDown))"
    }
}

extension TH2OTimerViewController: UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
}
