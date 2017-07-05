//
//  ComplicationController.swift
//  test WatchKit Extension
//
//  Created by Alessio Roberto on 02/07/2017.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import ClockKit
import WatchKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be
        // given the opportunity to update your complication content
        
        // handler(nil);
        //---update in the next 1 hour---
        handler(NSDate(timeIntervalSinceNow: 3600))
    }
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        print("Get current time line for complication: \(complication.family)")
        
        var template: CLKComplicationTemplate?
        var entry: CLKComplicationTimelineEntry?
        let now = NSDate()
        
        let userdef = UserDefaults.standard
        let value = userdef.integer(forKey: "progress")
        var goal = userdef.integer(forKey: "goal")
        if goal < 1 {
            goal = 2000
        }
        let progress = Double(Double(value) / Double(goal))
        
        let ok = "🏁"
        let error = "😭"
        var text: String
        if progress < 0 || progress > 1 {
            text = error
        } else {
            text = ok
        }
        
        print(value)
        print(goal)
        print(progress)
        
        switch complication.family {
        case .modularSmall:
            let modularSmallTemplate =
                CLKComplicationTemplateModularSmallRingText()
            
            modularSmallTemplate.textProvider =
                CLKSimpleTextProvider(text: text)
            modularSmallTemplate.fillFraction = Float(progress)
            modularSmallTemplate.ringStyle = CLKComplicationRingStyle.closed
            modularSmallTemplate.tintColor = .blue
            template = modularSmallTemplate
        case .circularSmall:
            let modularSmallTemplate =
                CLKComplicationTemplateCircularSmallRingText()

            modularSmallTemplate.textProvider =
                CLKSimpleTextProvider(text: text)
            modularSmallTemplate.fillFraction = Float(progress)
            modularSmallTemplate.ringStyle = CLKComplicationRingStyle.closed
            modularSmallTemplate.tintColor = .blue
            template = modularSmallTemplate
        case .utilitarianSmall:
            let utilitarianSmallTemplate = CLKComplicationTemplateUtilitarianSmallRingText()

            utilitarianSmallTemplate.textProvider =
                CLKSimpleTextProvider(text: text)
            utilitarianSmallTemplate.fillFraction = Float(progress)
            utilitarianSmallTemplate.ringStyle = CLKComplicationRingStyle.closed
            utilitarianSmallTemplate.tintColor = .blue
            template = utilitarianSmallTemplate
        case .utilitarianSmallFlat:
            let utilitarianSmallFlat = CLKComplicationTemplateUtilitarianSmallFlat()

            utilitarianSmallFlat.textProvider = CLKSimpleTextProvider(text: "\(value)💧")
            template = utilitarianSmallFlat
        case .utilitarianLarge:
            let utilitarianLarge = CLKComplicationTemplateUtilitarianLargeFlat()

            utilitarianLarge.textProvider = CLKSimpleTextProvider(text: "\(value) ml left")
            template = utilitarianLarge
        default:
            template = nil
        }
        
        if let template = template {
            print(template)
            entry = CLKComplicationTimelineEntry(date: now as Date, complicationTemplate: template)
        }
        
        handler(entry)
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        
        var template: CLKComplicationTemplate?
        
        switch complication.family {
        case .modularSmall:
            let modularSmallTemplate =
                CLKComplicationTemplateModularSmallRingText()
            modularSmallTemplate.textProvider =
                CLKSimpleTextProvider(text: " 💧")
            modularSmallTemplate.fillFraction = 0.75
            modularSmallTemplate.ringStyle = CLKComplicationRingStyle.closed
            template = modularSmallTemplate
        case .circularSmall:
            let modularSmallTemplate =
                CLKComplicationTemplateCircularSmallRingText()
            modularSmallTemplate.textProvider =
                CLKSimpleTextProvider(text: " 💧")
            modularSmallTemplate.fillFraction = 0.75
            modularSmallTemplate.ringStyle = CLKComplicationRingStyle.closed
            template = modularSmallTemplate
        case .utilitarianSmall:
            let utilitarianSmallTemplate = CLKComplicationTemplateUtilitarianSmallRingText()
            let userdef = UserDefaults.standard
            let value = userdef.integer(forKey: "progress")
            let progress = Double(Double(value) / 2000.0) * 100
            utilitarianSmallTemplate.textProvider =
                CLKSimpleTextProvider(text: " 💧")
            utilitarianSmallTemplate.fillFraction = Float(progress/100)
            utilitarianSmallTemplate.ringStyle = CLKComplicationRingStyle.closed
            utilitarianSmallTemplate.tintColor = .blue
            template = utilitarianSmallTemplate
        case .utilitarianSmallFlat:
            let utilitarianSmallFlat = CLKComplicationTemplateUtilitarianSmallFlat()
            let userdef = UserDefaults.standard
            let value = userdef.integer(forKey: "progress")
            utilitarianSmallFlat.textProvider = CLKSimpleTextProvider(text: "\(value)")
            template = utilitarianSmallFlat
        case .utilitarianLarge:
            let utilitarianLarge = CLKComplicationTemplateUtilitarianLargeFlat()
            let userdef = UserDefaults.standard
            let value = userdef.integer(forKey: "progress")
            utilitarianLarge.textProvider = CLKSimpleTextProvider(text: "\(value) ml left")
            template = utilitarianLarge
        default:
            template = nil
        }
        
        handler(template)
    }
    
}
