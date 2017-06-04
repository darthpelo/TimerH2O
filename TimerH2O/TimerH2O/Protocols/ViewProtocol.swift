//
//  ViewProtocol.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 29/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import Foundation

protocol ViewProtocol: class {
    func update(countDown: TimeInterval, amount: Double)
    func setTimerLabel(with string: String)
    func setAmountLabel(with string: String)
    func startButton(isEnabled: Bool)
    func stopTimerButton(isEnabled: Bool)
    func endSessionButton(isEnabled: Bool)
}
