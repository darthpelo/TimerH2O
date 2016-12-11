//
//  Configurable.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 10/12/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import Foundation
import UIKit

protocol Configurable {}

extension Configurable where Self: TH2OTimerViewController {
    internal func setupNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(didEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        notificationCenter.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    internal func setTimerLabel(with timerInterval: TimeInterval) {
        timerLabel.text = timerInterval.toString()
    }
    
    internal func configureWaterPickerView() {
        waterPickerView = TH2OWaterPickerView().loadPickerView()
        waterPickerView?.configure(onView: self.view, withCallback: { selectedAmount in
            self.presenter.update(water: Double(selectedAmount))
            self.waterPickerView?.isTo(show: false)
            self.presenter.startSession()
        })
    }
}

extension Configurable where Self: TH2OSetSessionViewController {
    internal func configureGesture() {
        let tapWater = UITapGestureRecognizer(target: self, action: #selector(handleTapWaterView))
        tapWater.delegate = self
        waterView.addGestureRecognizer(tapWater)
        
        let tapTimer = UITapGestureRecognizer(target: self, action: #selector(handleTapIntervalView))
        tapTimer.delegate = self
        intervalView.addGestureRecognizer(tapTimer)
    }
    
    internal func configureLabels() {
        titleLabel.text = NSLocalizedString("setsession.title.label", comment: "")
        waterAmountTextLabel.text = NSLocalizedString("setsession.amount.label", comment: "")
        intervalTextLabel.text = NSLocalizedString("setsession.interval.label", comment: "")
    }
    
    internal func configureWaterPickerView() {
        waterPickerView = TH2OWaterPickerView().loadPickerView()
        waterPickerView?.configure(onView: self.view, withCallback: { selectedAmount in
            self.water = selectedAmount
            self.waterAmountLabel.text = "\(selectedAmount) cl"
            self.waterPickerView?.isTo(show: false)
        })
    }
    
    internal func configureTimerPickerView() {
        timerPickerView = TH2OTimerPickerView().loadDatePickerView()
        timerPickerView?.configure(onView: self.view, withCallback: { selectedTimer in
            self.interval = selectedTimer
            self.intervalLabel.text = "\(Int(selectedTimer/60)) min"
            self.timerPickerView?.isTo(show: false)
        })
    }
}

