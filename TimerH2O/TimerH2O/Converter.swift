//
//  Converter.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 29/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import Foundation

func convert(amount: [String]) -> Int? {
    var result: String = ""
    for c in amount {
        result = result + c
    }
    return Int(result)
}
