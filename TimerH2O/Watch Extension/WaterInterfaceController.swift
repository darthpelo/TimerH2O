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
    @IBOutlet weak var myTimer: WKInterfaceTimer!
    
    var timerStarted = false
    
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
            waterLabel.setText("\(progress) ml")
        }
    }
    
    var countDown: TimeInterval? {
        didSet {
            guard let countDown = countDown else { return }
            
            if timerStarted == false && countDown > 0 {
                myTimer.setDate(Date(timeInterval: countDown, since: Date()))
                myTimer.start()
                timerStarted = true
            } else if timerStarted == true && countDown == 0 {
                myTimer.stop()
                myTimer.setDate(Date(timeInterval: countDown, since: Date()))
                timerStarted = false
            }
            
            if countDown > 60 {
                myTimer.setTextColor(.white)
            } else {
                myTimer.setTextColor(.red)
            }
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        update()
        
        watchSession = WCSession.default
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
        let value = userdef.integer(forKey: DictionaryKey.progress.rawValue)
        let timer = userdef.double(forKey: DictionaryKey.countDown.rawValue)
        
        progress = value
        countDown = timer
    }
    
    fileprivate func refreshComplications() {
        let server = CLKComplicationServer.sharedInstance()
        guard let complications = server.activeComplications else { return }
        for complication in complications {
            server.reloadTimeline(for: complication)
        }
    }
}

extension WaterInterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        if let goal = applicationContext[DictionaryKey.goal.rawValue] as? Int {
            let userdef = UserDefaults.standard
            userdef.set(goal, forKey: DictionaryKey.goal.rawValue)
        }
        
        if let progress = applicationContext[DictionaryKey.progress.rawValue] as? Int {
            self.progress = progress
            let userdef = UserDefaults.standard
            userdef.set(progress, forKey: DictionaryKey.progress.rawValue)
        }
        
        if let countDown = applicationContext[DictionaryKey.countDown.rawValue] as? TimeInterval {
            self.countDown = countDown
            let userdef = UserDefaults.standard
            userdef.set(countDown, forKey: DictionaryKey.countDown.rawValue)
        }
        
        refreshComplications()
    }
}
