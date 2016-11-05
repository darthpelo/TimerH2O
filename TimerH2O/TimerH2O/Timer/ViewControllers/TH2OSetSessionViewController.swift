//
//  TH2OSetSessionViewController.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 27/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit

class TH2OSetSessionViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var waterView: UIView!
    @IBOutlet weak var waterAmountLabel: UILabel!
    @IBOutlet weak var intervalView: UIView!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    lazy var presenter: Presenter = Presenter(view: self)
    
    public var waterPickerView: TH2OWaterPickerView?
    public var timerPickerView: TH2OTimerPickerView?
    private var water: Int?
    private var interval: TimeInterval?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapWater = UITapGestureRecognizer(target: self, action: #selector(handleTapWaterView))
        tapWater.delegate = self
        waterView.addGestureRecognizer(tapWater)
        
        let tapTimer = UITapGestureRecognizer(target: self, action: #selector(handleTapIntervalView))
        tapTimer.delegate = self
        intervalView.addGestureRecognizer(tapTimer)
        
        configureWaterPickerView()
        configureTimerPickerView()
    }

    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        self.performSegue(withIdentifier: R.segue.tH2OSetSessionViewController.backToTimerVC, sender: self)
    }

    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        guard let water = self.water, let interval = self.interval else {
            return
        }
        presenter.save(model: Model(water: water, interval: interval))
        self.performSegue(withIdentifier: R.segue.tH2OSetSessionViewController.backToTimerVC, sender: self)
    }
    
    private func configureWaterPickerView() {
        waterPickerView = TH2OWaterPickerView().loadPickerView()
        waterPickerView?.configure(onView: self.view, withCallback: { selectedAmount in
            self.water = selectedAmount
            self.waterAmountLabel.text = "\(selectedAmount) cl"
            self.waterPickerView?.isTo(show: false)
        })
    }
    
    private func configureTimerPickerView() {
        timerPickerView = TH2OTimerPickerView().loadDatePickerView()
        timerPickerView?.configure(onView: self.view, withCallback: { selectedTimer in
            self.interval = selectedTimer
            self.intervalLabel.text = "\(Int(selectedTimer/60)) min"
            self.timerPickerView?.isTo(show: false)
        })
    }
}
