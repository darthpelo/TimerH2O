//
//  Timer.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 03/11/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import Foundation

typealias ScheduledTimer = ()->()

public class TimerManager {
    
    class var sharedInstance: TimerManager {
        struct Singleton {
            static let instance = TimerManager()
        }
        return Singleton.instance
    }
    
    var scheduledTimer: ScheduledTimer?
    
    private var timer = Timer()
    
    func start() {
        if self.timer.isValid == false {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(sendNotification), userInfo: nil, repeats: true)
        }
    }
    
    func stop() {
        self.timer.invalidate()
    }
    
    @objc func sendNotification() {
        scheduledTimer?()
    }
}
