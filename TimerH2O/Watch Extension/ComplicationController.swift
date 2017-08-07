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
    
    func getNextRequestedUpdateDate(handler: @escaping (Date?) -> Swift.Void) {
        // Call the handler with the date when you would next like to be
        // given the opportunity to update your complication content
        //---update in the next 1 hour---
        handler(Date(timeIntervalSinceNow: 3600))
    }
    
    func requestedUpdateDidBegin() {
        reloadOrExtendData()
    }
    func requestedUpdateBudgetExhausted() {
        reloadOrExtendData()
    }
    
    func reloadOrExtendData() {
        let server = CLKComplicationServer.sharedInstance()
        guard let complications = server.activeComplications,
            complications.count > 0 else { return }
        
        // To invalidate the existing data
        for complication in complications {
            server.reloadTimeline(for: complication)
        }
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
    
    // Call the handler with the current timeline entry
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        var entry: CLKComplicationTimelineEntry?
        let now = NSDate()
        
        if let template = complicationTemplate(complication.family) {
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
            let value = userdef.integer(forKey: DictionaryKey.progress.rawValue)
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
            let value = userdef.integer(forKey: DictionaryKey.progress.rawValue)
            utilitarianSmallFlat.textProvider = CLKSimpleTextProvider(text: "\(value)")
            template = utilitarianSmallFlat
        case .utilitarianLarge:
            let utilitarianLarge = CLKComplicationTemplateUtilitarianLargeFlat()
            let userdef = UserDefaults.standard
            let value = userdef.integer(forKey: DictionaryKey.progress.rawValue)
            utilitarianLarge.textProvider = CLKSimpleTextProvider(text: "\(value) ml left")
            template = utilitarianLarge
        default:
            template = nil
        }
        
        handler(template)
    }
    
    // MARK: - Private
    private func complicationTemplate(_ family: CLKComplicationFamily) -> CLKComplicationTemplate? {
        logger(object: "Get current time line for complication: \(family)")
        
        var template: CLKComplicationTemplate?
        let value = UserDefaults.standard.integer(forKey: DictionaryKey.progress.rawValue)
        let progress = self.progress(ofValue: value)
        
        var text: String
        if progress < 0 || progress > 1 {
            text = WatchText.error.rawValue
        } else if progress == 0 {
            text = WatchText.ok.rawValue
        } else {
            text = WatchText.onGoing.rawValue
        }
        
        switch family {
        case .modularSmall:
            template = modularSmallTemplate(text, progress)
        case .circularSmall:
            template = circularSmallTemplate(text, progress)
        case .utilitarianSmall:
            template = utilitarianSmallTemplate(text, progress)
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
        
        return template
    }
    
    private func progress(ofValue value: Int) -> Double {
        var goal = UserDefaults.standard.integer(forKey: DictionaryKey.goal.rawValue)
        if goal < 1 { goal = 2000 }
        
        return Double(Double(value) / Double(goal))
    }
    
    private func modularSmallTemplate(_ text: String, _ progress: Double) -> CLKComplicationTemplate? {
        let modularSmallTemplate =
            CLKComplicationTemplateModularSmallRingText()
        
        modularSmallTemplate.textProvider = CLKSimpleTextProvider(text: text)
        modularSmallTemplate.fillFraction = Float(progress)
        modularSmallTemplate.ringStyle = CLKComplicationRingStyle.closed
        modularSmallTemplate.tintColor = .blue
        return modularSmallTemplate
    }
    
    private func circularSmallTemplate(_ text: String, _ progress: Double) -> CLKComplicationTemplate? {
        let circularSmallTemplate =
            CLKComplicationTemplateCircularSmallRingText()
        
        circularSmallTemplate.textProvider = CLKSimpleTextProvider(text: text)
        circularSmallTemplate.fillFraction = Float(progress)
        circularSmallTemplate.ringStyle = CLKComplicationRingStyle.closed
        circularSmallTemplate.tintColor = .blue
        
        return circularSmallTemplate
    }
    
    private func utilitarianSmallTemplate(_ text: String, _ progress: Double) -> CLKComplicationTemplate? {
        let utilitarianSmallTemplate = CLKComplicationTemplateUtilitarianSmallRingText()
        
        utilitarianSmallTemplate.textProvider =
            CLKSimpleTextProvider(text: text)
        utilitarianSmallTemplate.fillFraction = Float(progress)
        utilitarianSmallTemplate.ringStyle = CLKComplicationRingStyle.closed
        utilitarianSmallTemplate.tintColor = .blue
        
        return utilitarianSmallTemplate
    }
}
