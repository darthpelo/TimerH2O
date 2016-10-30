//
//  TH2OSetSessionVCExtensions.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 29/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import Foundation
import UIKit

extension TH20SetSessionViewController: UIGestureRecognizerDelegate {
    func handleTapWaterView() {
        waterPickerView?.pickerView(isToShow: true)
    }
}

extension TH20SetSessionViewController: ViewProtocol {
    
}
