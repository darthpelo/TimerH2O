//
//  TH2OSetSessionVCExtensions.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 29/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import Foundation
import UIKit

extension TH2OSetSessionViewController: UIGestureRecognizerDelegate {
    func handleTapWaterView() {
        waterPickerView?.isTo(show: true)
    }
    
    func handleTapIntervalView() {
        timerPickerView?.isTo(show: true)
    }
}

extension TH2OSetSessionViewController: ViewProtocol {
    internal func stopTimerButton(isEnabled: Bool) {}

    internal func startButton(isEnabled isEbable: Bool) {}

    internal func setAmountLabel(with string: String) {}

    internal func update(countDown: TimeInterval, amount: Double) {}

    internal func setTimerLabel(with string: String) {}

    internal func update(countDown: TimeInterval) {}
}
