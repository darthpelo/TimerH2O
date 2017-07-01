//
//  WaterInterfaceController.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 29/06/2017.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class WaterInterfaceController: WKInterfaceController {
    @IBOutlet var waterLabel: WKInterfaceLabel!
    
    var watchSession: WCSession? {
        didSet {
            if let session = watchSession {
                session.delegate = self
                session.activate()
            }
        }
    }
    
    var progress: Int? {
        didSet {
            guard let progress = progress else { return }
            waterLabel.setText("\(progress)")
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        update()
        
        watchSession = WCSession.default()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        update()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        update()
    }

    private func update() {
        let userdef = UserDefaults.standard
        let value = userdef.integer(forKey: "progress")
        progress = value
    }
}

extension WaterInterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Session activation did complete")
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("watch received app context: ", applicationContext)
        if let progress = applicationContext["progress"] as? Int {
            self.progress = progress
            let userdef = UserDefaults.standard
            userdef.set(progress, forKey: "progress")
        }
    }
}