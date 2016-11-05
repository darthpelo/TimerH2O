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
    
    fileprivate var countDown = 10
    
    lazy var presenter: Presenter = Presenter(view: self)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !SessionManager().sessionStart() {
            self.performSegue(withIdentifier: R.segue.tH2OTimerViewController.newSessionVC, sender: self)
        } else {
            presenter.startSession()
        }
        
        timerLabel.text = "\(countDown)"
    }

    @IBAction func drinkButtonPressed(_ sender: AnyObject) {
    }
    
    @IBAction func unwindToTimer(segue: UIStoryboardSegue) {}
    
}

extension TH2OTimerViewController: ViewProtocol {
    internal func updateCounter() {
        countDown -= 1
        
        if countDown == 0 {
            presenter.stopSession()
        }
        
        timerLabel.text = "\(countDown)"
    }
}
