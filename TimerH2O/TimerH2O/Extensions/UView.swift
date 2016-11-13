//
//  UView.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 06/11/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set(value) {
            layer.borderWidth = value
        }
    }
    
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return layer.borderColor != nil ? UIColor(cgColor: layer.borderColor!) : nil
        }
        set(value) {
            layer.borderColor = value?.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set(value) {
            layer.cornerRadius = value
        }
    }
}
