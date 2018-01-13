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
        notificationCenter.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    internal func configureWaterPickerView() {
        waterPickerView = TH2OWaterPickerView().loadPickerView()
        
        waterPickerView?.configure(onView: self.view, withCallback: { [weak self] selectedAmount in
            self?.presenter.update(water: Double(selectedAmount))
            self?.waterPickerView?.isTo(show: false)
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
        titleLabel.text = R.string.localizable.setsessionTitleLabel()
        waterAmountTextLabel.text = R.string.localizable.setsessionAmountLabel()
        intervalTextLabel.text = R.string.localizable.setsessionIntervalLabel()
    }
    
    internal func configureWaterPickerView() {
        waterPickerView = TH2OWaterPickerView().loadPickerView()
        waterPickerView?.configure(onView: self.view, withCallback: { selectedAmount in
            self.water = selectedAmount
            self.waterAmountLabel.text = "\(selectedAmount) mL"
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

extension Configurable where Self: TH2OMoreDetailViewController {
    internal func configureWebView() {
        title = title(self.type)
        
        webView.frame = self.webViewContainer.frame
        webViewContainer.addSubview(self.webView)
                
        if let string = self.url(self.type),
            let url = URL.init(string: string) {
            webView.navigationDelegate = self
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
            webView.load(request)
        }
    }
    
    private func title(_ type: MoreDetail?) -> String {
        guard let type = type else {
            return ""
        }
        
        switch type {
        case .acknowledgements:
            return R.string.localizable.moreAcknowledgements()
        case .privacy:
            return R.string.localizable.morePrivacy()
        case .healthData:
            return R.string.localizable.moreHealthData()
        }
    }
    
    private func url(_ type: MoreDetail?) -> String? {
        guard let type = type else {
            return nil
        }
        
        switch type {
        case .acknowledgements:
            return "http://www.timerh2o.info/timerh2o.html"
        case .privacy:
            return "http://www.timerh2o.info/privacy.html"
        default:
            return nil
        }
    }
}

extension Configurable where Self: TH2OHealthDataViewController {
    internal func configureView() {
        title = R.string.localizable.moreHealthDataTitle()
        
        firstLabel.text = R.string.localizable.moreHealthDataFirstLabel()
        secondLabel.text = R.string.localizable.moreHealthDataSecondLabel()
        switchLabel.text = R.string.localizable.moreHealthDataSwitchLabel()
    }
}
