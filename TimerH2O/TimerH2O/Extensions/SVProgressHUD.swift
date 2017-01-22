//
//  SVProgressHUD.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 22/01/2017.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import SVProgressHUD

extension SVProgressHUD {
    /// Present a custom version of the spinner with an optional text status
    ///
    /// - Parameter status: The status. Nil it is the default
    class func show(withTitle status: String? = nil) {
        if let status = status {
            SVProgressHUD.show(withStatus: status)
        } else {
            SVProgressHUD.show()
        }
        
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.native)
        SVProgressHUD.setForegroundColor(.white)
        SVProgressHUD.setBackgroundLayerColor(UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.75))
    }
}
