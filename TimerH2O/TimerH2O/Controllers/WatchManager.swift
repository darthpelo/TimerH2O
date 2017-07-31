//
//  WatchManager.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 01/07/2017.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchManager: NSObject {
    fileprivate var watchSession: WCSession?
    
    class var sharedInstance: WatchManager {
        struct Singleton {
            static let instance = WatchManager()
        }
        return Singleton.instance
    }
    
    override init() {
        super.init()
        watchSession = WCSession.default()
        watchSession?.delegate = self
        watchSession?.activate()
    }
    
    func update(water: Double, countDown: TimeInterval) {
        let progress: Int = Int(water)
        
        sendDictionary(["progress": progress, "countDown": countDown])
    }
    
    private func sendDictionary(_ dict: [String: Any]) {
        do {
            try self.watchSession?.updateApplicationContext(dict)
            AnswerManager().log(event: "Sent data to Apple Watch")
        } catch {
            print("Error sending dictionary \(dict) to Apple Watch!")
            AnswerManager().log(event: "Error sending data to Apple Watch")
        }
    }
}

// MARK: WCSessionDelegate
extension WatchManager: WCSessionDelegate {
    
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Session activation did complete")
    }
    
    public func sessionDidBecomeInactive(_ session: WCSession) {
        print("session did become inactive")
    }
    
    public func sessionDidDeactivate(_ session: WCSession) {
        print("session did deactivate")
    }
}
