//
//  HealthManager.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 02/01/17.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import Foundation
import HealthKit

final class HealthManager {
    let healthKitStore: HKHealthStore = HKHealthStore()
    
    // Set the types you want to read from HK Store
    private let healthKitTypesToRead: Set<HKObjectType> = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!]
    
    // Set the types you want to write to HK Store
    private let healthKitTypesToWrite: Set<HKSampleType> = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!]
    
    func isAuthorized() -> Bool {
        switch healthKitStore.authorizationStatus(for: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!) {
        case .sharingAuthorized:
            return true
        default:
            return false
        }
    }
    
    func authorizeHealthKit(completion: ((_ success: Bool, _ error: Error?) -> Void)!) {
        // If the store is not available (for instance, iPad) return an error and don't go on.
        if !HKHealthStore.isHealthDataAvailable() {
            let error = NSError(domain: "com.alessioroberto.TimerH2O", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
            if completion != nil {
                completion(false, error)
            }
            return
        }
        
        // Request HealthKit authorization
        healthKitStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) -> Void in
            
            if completion != nil {
                completion(success, error)
            }
        }
    }
    
    func saveWaterSample(_ water: Double, startDate: Date, endDate: Date) {
        if let waterType = HKQuantityType.quantityType(forIdentifier: .dietaryWater) {
            let waterQuantity = HKQuantity(unit: HKUnit.liter(), doubleValue: water)
            let waterSample = HKQuantitySample(type: waterType, quantity: waterQuantity, start: startDate, end: endDate)
            
            healthKitStore.save(waterSample, withCompletion: { (success, error) in
                if error != nil {
                    NSLog("Error saving water sample: \(error?.localizedDescription)")
                } else {
                    NSLog("Water sample saved successfully!")
                }
            })
        }
    }
}
