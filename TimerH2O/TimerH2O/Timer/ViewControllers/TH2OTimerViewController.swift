//
//  TH2OTimerViewController.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 23/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit
import UserNotifications
import Instructions

class TH2OTimerViewController: UIViewController, Configurable, Seguible {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var amountLabe: UILabel!
    @IBOutlet weak var startNewSessionButton: UIButton! {
        didSet {
            startNewSessionButton.setTitle(R.string.localizable.timerviewStartButton(), for: .normal)
        }
    }
    @IBOutlet weak var stopTimerButton: UIButton! {
        didSet {
            stopTimerButton.setTitle(R.string.localizable.timerviewStopButton(), for: .normal)
        }
    }
    @IBOutlet weak var endSessionButton: UIButton! {
        didSet {
            endSessionButton.setTitle(R.string.localizable.timerviewEndButton(), for: .normal)
        }
    }
    
    public var waterPickerView: TH2OWaterPickerView?
//    private let healthManager = HealthManager()
    
    let coachMarksController = CoachMarksController()
    
    lazy var presenter: Presenter = Presenter(view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure User Notification Center
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
        }
        
        self.coachMarksController.dataSource = self
        self.coachMarksController.overlay.blurEffectStyle = .dark
        self.coachMarksController.overlay.allowTap = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if presenter.sessionIsStarted() {
            startButton(isEnabled: false)
            stopTimerButton(isEnabled: true)
            endSessionButton(isEnabled: true)
            presenter.updateWatch()
        } else {
            startButton(isEnabled: true)
            stopTimerButton(isEnabled: false)
            endSessionButton(isEnabled: false)
        }
        
        presenter.setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AnswerManager().log(event: "TimerViewController")
        
        setupNotification()
        notificationsSettings()
        configureWaterPickerView()
        
        if UserDefaults().timerCoachShowed == false {
           self.coachMarksController.start(on: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.coachMarksController.stop(immediately: true)
    }
    
    // MARK: - Actions
    @IBAction func newSessionPressed(_ sender: Any) {
        AnswerManager().log(event: "newSessionPressed")
        newSession()
    }
    
    @IBAction func drinkButtonPressed(_ sender: AnyObject) {
        if presenter.sessionIsStarted() && presenter.intervalIsStarted() {
            AnswerManager().log(event: "drinkButtonPressed")
            presenter.endInterval()
            showWaterPicker()
        }
    }
    
    @IBAction func endSessionButtonPressed(_ sender: Any) {
        AnswerManager().log(event: "endSessionButtonPressed")
        presenter.stopSession()
    }
    
    @IBAction func unwindToTimer(segue: UIStoryboardSegue) {
        configureWaterPickerView()
        presenter.startSession()
        presenter.startInterval()
    }
    
    // MARK: - didEnterBackground & didBecomeActive
    func didEnterBackground() {
        presenter.stopTimer()
    }
    
    @objc func didBecomeActive() {
        if #available(iOS 10.0, *) {
            if presenter.sessionIsStarted() {
                presenter.setupView()
                presenter.updateWatch()
            }
        }
    }
    
    internal func showWaterPicker() {
        waterPickerView?.isTo(show: true)
    }
    
    // MARK: - Private
    
    fileprivate func snozee(_ time: Snooze) {
        presenter.updateWatch()
        localNotificationRequest(snooze: time)
    }
}

extension TH2OTimerViewController: ViewProtocol {
    internal func update(countDown: TimeInterval, amount: Double) {
        if countDown <= 0 {
            presenter.endInterval()
            DispatchQueue.main.async { [weak self] in
                self?.showWaterPicker()
                self?.setAmountLabel(with: "\(amount)")
            }
        } else {
            setTimerLabel(with: countDown.toString())
        }
    }
    
    internal func setTimerLabel(with string: String) {
        timerLabel.text = string
    }
    
    internal func startButton(isEnabled: Bool) {
        startNewSessionButton.isEnabled = isEnabled
    }
    
    internal func stopTimerButton(isEnabled: Bool) {
        stopTimerButton.isEnabled = isEnabled
    }
    
    internal func endSessionButton(isEnabled: Bool) {
        endSessionButton.isEnabled = isEnabled
    }
    
    internal func setAmountLabel(with string: String) {
        amountLabe.text = string
    }
}

extension TH2OTimerViewController: UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let actionIdentifier = response.actionIdentifier
        
        switch actionIdentifier {
        case UNNotificationDismissActionIdentifier: // Notification was dismissed by user
            completionHandler()
        case UNNotificationDefaultActionIdentifier: // App was opened from notification
            presenter.setupView()
            completionHandler()
        case TH2OConstants.UserNotification.drinkAction:
            AnswerManager().log(event: "Notification Action", withCustomAttributes: ["action": TH2OConstants.UserNotification.drinkAction])
            presenter.setupView()
            completionHandler()
        case TH2OConstants.UserNotification.snooze5Action:
            AnswerManager().log(event: "Notification Action", withCustomAttributes: ["action": TH2OConstants.UserNotification.snooze5Action])
            snozee(Snooze.five)
            completionHandler()
        case TH2OConstants.UserNotification.snooze15Action:
            AnswerManager().log(event: "Notification Action", withCustomAttributes: ["action": TH2OConstants.UserNotification.snooze15Action])
            snozee(Snooze.fifteen)
            completionHandler()
        case TH2OConstants.UserNotification.snooze30Action:
            AnswerManager().log(event: "Notification Action", withCustomAttributes: ["action": TH2OConstants.UserNotification.snooze30Action])
            snozee(Snooze.thirty)
            completionHandler()
        default:
            completionHandler()
        }
    }
    
}
