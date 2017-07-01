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
    private let healthManager = HealthManager()
    
    let coachMarksController = CoachMarksController()
    
    lazy var presenter: Presenter = Presenter(view: self, healthManager: self.healthManager)
    
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
        
        if SessionManager().sessionIsStart() {
            startButton(isEnabled: false)
            stopTimerButton(isEnabled: true)
            endSessionButton(isEnabled: true)
            presenter.updateWatch()
        } else {
            startButton(isEnabled: true)
            stopTimerButton(isEnabled: false)
            endSessionButton(isEnabled: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AnswerManager().log(event: "TimerViewController")
        
        setupNotification()
        notificationsSettings()
        
        if SessionManager().sessionIsStart() {
            configureWaterPickerView()
            timerCheck()
        }
        
        setAmountLabel(with: SessionManager().amountOfWater())
        
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
        if SessionManager().sessionIsStart() && SessionManager().intervalIsStart() {
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
        setTimerLabel(with: SessionManager().timeInterval())
        configureWaterPickerView()
        presenter.startSession()
        presenter.startInterval()
    }
    
    // MARK: - didEnterBackground & didBecomeActive
    func didEnterBackground() {
        presenter.stopTimer()
    }
    
    func didBecomeActive() {
        if #available(iOS 10.0, *) {
            if SessionManager().sessionIsStart() {
                timerCheck()
                presenter.updateWatch()
            }
        }
    }
    
    // MARK: - Private
    fileprivate func showWaterPicker() {
        waterPickerView?.isTo(show: true)
    }
    
    fileprivate func timerCheck() {
        if let timeInterval = SessionManager().endTimer()?.timeIntervalSince(Date()), timeInterval > 0 {
            self.presenter.startTimer(timeInterval)
        } else {
            presenter.endInterval()
            DispatchQueue.main.async { [weak self] in
                self?.showWaterPicker()
            }
        }
    }
    
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
                self?.setAmountLabel(with: amount)
            }
        } else {
            setTimerLabel(with: countDown)
        }
    }
    
    internal func setTimerLabel(with string: String) {
        timerLabel.text = string
    }
    
    internal func setAmountLabel(with string: String) {
        amountLabe.text = string
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
            completionHandler(timerCheck())
        case TH2OConstants.UserNotification.drinkAction:
            AnswerManager().log(event: "Notification Action", withCustomAttributes: ["action": TH2OConstants.UserNotification.drinkAction])
            completionHandler(timerCheck())
        case TH2OConstants.UserNotification.snooze5Action:
            AnswerManager().log(event: "Notification Action", withCustomAttributes: ["action": TH2OConstants.UserNotification.snooze5Action])
            completionHandler(snozee(Snooze.five))
        case TH2OConstants.UserNotification.snooze15Action:
            AnswerManager().log(event: "Notification Action", withCustomAttributes: ["action": TH2OConstants.UserNotification.snooze15Action])
            completionHandler(snozee(Snooze.fifteen))
        case TH2OConstants.UserNotification.snooze30Action:
            AnswerManager().log(event: "Notification Action", withCustomAttributes: ["action": TH2OConstants.UserNotification.snooze30Action])
            completionHandler(snozee(Snooze.thirty))
        default:
            completionHandler()
        }
    }
    
}

enum Mark: Int {
    case one
    case two
    case three
}

extension TH2OTimerViewController: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return Mark.three.rawValue + 1
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        if index == Mark.one.rawValue {
            return coachMarksController.helper.makeCoachMark(for: self.startNewSessionButton)
        } else if index == Mark.two.rawValue {
            return coachMarksController.helper.makeCoachMark(for: self.stopTimerButton)
        } else {
            return coachMarksController.helper.makeCoachMark(for: self.endSessionButton)
        }
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkViewsAt index: Int,
                              madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        
        if index == Mark.one.rawValue {
            coachViews.bodyView.hintLabel.text = R.string.localizable.coachMarkOne()
            coachViews.bodyView.nextLabel.text = "👌"
            
            return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
        } else if index == Mark.two.rawValue {
            coachViews.bodyView.hintLabel.text = R.string.localizable.coachMarkTwo()
            coachViews.bodyView.nextLabel.text = "👌"
            
            return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
        } else {
            coachViews.bodyView.hintLabel.text = R.string.localizable.coachMarkThree()
            coachViews.bodyView.nextLabel.text = "🎉"
            UserDefaults().timerCoachShowed = true
            return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
        }

    }
}
