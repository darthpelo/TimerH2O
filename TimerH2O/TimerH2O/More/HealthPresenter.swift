//
//  HealthPresenter.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 01/08/2017.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import Foundation

struct HealthPresenter {
    weak var healthManager: HealthManager?
    
    func healthKitIsAuthorized() -> Bool {
        guard let healthManager = healthManager else {
            return false
        }
        return healthManager.isAuthorized()
    }
    
    func healthKitAuthorize(completion: @escaping ((_ success: Bool) -> Void)) {
        guard let healthManager = healthManager else {
            completion(false)
            return
        }
        
        healthManager.authorizeHealthKit { (authorized, error) in
            if authorized {
                return completion(authorized)
            } else {
                if error != nil {
                    NSLog("\(String(describing: error))")
                }
                return completion(authorized)
            }
        }
    }
}
