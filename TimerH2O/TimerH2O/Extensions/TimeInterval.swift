//
//  TimeInterval.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 11/12/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    /// Convert TimeInterval instance in a String with the format "00:00:00" (hours:minutes:seconds)
    ///
    /// - Returns: The String rappresentation of the TimeInterval
    func toString(withSeconds seconds: Bool = true) -> String {
        let ti = NSInteger(self)

        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        if seconds {
            let seconds = ti % 60
            return String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
        } else {
            return String(format: "%0.2d:%0.2d", hours, minutes)
        }
        
    }
}
