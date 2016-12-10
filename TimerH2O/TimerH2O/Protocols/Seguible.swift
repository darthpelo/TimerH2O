//
//  Seguible.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 10/12/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import Foundation

protocol Seguible {}

extension Seguible where Self: TH2OSetSessionViewController {
    internal func backToTimer() {
        performSegue(withIdentifier: R.segue.tH2OSetSessionViewController.backToTimerVC.identifier, sender: nil)
    }
}

extension Seguible where Self: TH2OTimerViewController {
    internal func newSession() {
        performSegue(withIdentifier: R.segue.tH2OTimerViewController.newSessionVC.identifier, sender: self)
    }
}
