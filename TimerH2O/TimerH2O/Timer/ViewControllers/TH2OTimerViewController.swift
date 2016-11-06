//
//  TH2OTimerViewController.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 23/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit

class TH2OTimerViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    
    fileprivate var countDown: TimeInterval = 0
    
    lazy var presenter: Presenter = Presenter(view: self)
    
    //TODO: - temporary
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SessionManager().newSession(isStart: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !SessionManager().sessionStart() {
            self.performSegue(withIdentifier: R.segue.tH2OTimerViewController.newSessionVC, sender: self)
        } else {
            presenter.startSession()
        }
        
        timerLabel.text = "\(convert(second: countDown))"
    }

    @IBAction func drinkButtonPressed(_ sender: AnyObject) {
    }
    
    @IBAction func unwindToTimer(segue: UIStoryboardSegue) {
        countDown = SessionManager().timeInterval()
        timerLabel.text = "\(convert(second: countDown))"
    }
    
}

extension TH2OTimerViewController: ViewProtocol {
    internal func updateCounter() {
        countDown -= 1
        
        if countDown == 0 {
            presenter.stopSession()
        }
        
        timerLabel.text = "\(convert(second: countDown))"
    }
}
