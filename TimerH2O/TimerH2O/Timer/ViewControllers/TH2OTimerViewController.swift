//
//  TH2OTimerViewController.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 23/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit

class TH2OTimerViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !SessionManager().sessionStart() {
            self.performSegue(withIdentifier: R.segue.tH2OTimerViewController.newSessionVC, sender: self)
        }
    }

    @IBAction func unwindToTimer(segue: UIStoryboardSegue) {}
}
