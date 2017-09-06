//
//  Converter.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 29/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import Foundation

struct Converter {
    /// Convert a [String] in a format ["x", "x", "x"] in an Int.
    ///
    /// For example ["1", "0", "0"] = 100.
    ///
    /// - Parameter amount: The array that rappresent a number
    /// - Returns: The number
    static func convert(amount: [String]) -> Int? {
        var result: String = ""
        for c in amount {
            result += c
        }
        return Int(result)
    }
}
