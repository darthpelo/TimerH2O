//
//  Logger.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 16/07/2017.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import Foundation

func logger<T>(object: T, filename: String = #file, line: Int = #line, funcname: String = #function) {
    #if DEBUG
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss:SSS"
        let process = ProcessInfo.processInfo
        
        print("\(dateFormatter.string(from: NSDate() as Date)) \(process.processName))[\(process.processIdentifier)]\n \(filename)(\(line))\n \(funcname):\r\t\(object)\n")
    #endif
}
