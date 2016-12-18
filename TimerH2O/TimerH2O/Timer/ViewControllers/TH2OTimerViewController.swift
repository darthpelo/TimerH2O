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
    @IBOutlet weak var amountLabe: UILabel!
    @IBOutlet weak var startNewSessionButton: UIButton! {
        didSet {
            startNewSessionButton.setTitle("Start", for: .normal)
        }
    }
    @IBOutlet weak var stopTimerButton: UIButton! {
        didSet {
            stopTimerButton.setTitle(NSLocalizedString("timerview.stop.button", comment: ""), for: .normal)
        }
    }
    
    public var waterPickerView: TH2OWaterPickerView?
    
    lazy var presenter: Presenter = Presenter(view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure User Notification Center
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        setupNotification()
        notificationsSettings()

        setAmountLabel(with: SessionManager().amountOfWater())
                
//        if SessionManager().sessionStart() {
//            configureWaterPickerView()
//            presenter.startSession()
//        } else {
//            timerLabel.text = NSLocalizedString("timerview.timer.label.finish_vc", comment: "")
//        }
    }

    @IBAction func newSessionPressed(_ sender: Any) {
        presenter.stopSession()
        newSession()
    }
    
    @IBAction func drinkButtonPressed(_ sender: AnyObject) {
        if SessionManager().sessionIsStart() && SessionManager().intervalIsStart() {
            presenter.endInterval()
            showWaterPicker()
        }
    }
    
    @IBAction func unwindToTimer(segue: UIStoryboardSegue) {
        setTimerLabel(with: SessionManager().timeInterval())
        configureWaterPickerView()
        presenter.startSession()
        presenter.startInterval()
    }
    
    func didEnterBackground() {
        presenter.stopTimer()
        presenter.startLocalNotification()
    }
    
    func didBecomeActive() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        if #available(iOS 10.0, *) {
            if let timeInterval = SessionManager().endTimer()?.timeIntervalSince(Date()), timeInterval > 0 {
                    self.presenter.startTimer(timeInterval)
            } else {
                presenter.stopSession()
                DispatchQueue.main.async { [weak self] in
                    self?.showWaterPicker()
                }
            }
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [TH2OConstants.UserNotification.notificationRequest])
        }
    }
    
    //MARK: - Private
    fileprivate func showWaterPicker() {
        waterPickerView?.isTo(show: true)
    }
}

extension TH2OTimerViewController: ViewProtocol {
    internal func update(countDown: TimeInterval, amount: Double) {
        if countDown == 0 {
            presenter.stopSession()
            DispatchQueue.main.async { [weak self] in
                self?.showWaterPicker()
                self?.setAmountLabel(with: amount)
            }
        } else {
            setTimerLabel(with: countDown)
            setAmountLabel(with: amount)
        }
    }
    
    internal func setTimerLabel(with string: String) {
        timerLabel.text = string
    }
    
    internal func setAmountLabel(with string: String) {
        amountLabe.text = string
    }
}

extension TH2OTimerViewController: UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
}
