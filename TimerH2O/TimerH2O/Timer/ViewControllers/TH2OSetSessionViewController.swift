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
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    lazy var presenter: Presenter = Presenter(view: self)
    
    var waterPickerView: TH2OWaterPickerView?
    var timerPickerView: TH2OTimerPickerView?
    
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

    private func configureWaterPickerView() {
        waterPickerView = TH2OWaterPickerView().loadPickerView()
        waterPickerView?.configure(onView: self.view, withCallback: { [weak self] selectedAmount in
            self?.waterAmountLabel.text = "\(selectedAmount)cl"
            self?.waterPickerView?.isTo(show: false)
        })
    }
    
    private func configureTimerPickerView() {
        timerPickerView = TH2OTimerPickerView().loadDatePickerView()
        timerPickerView?.configure(onView: self.view, withCallback: { [weak self] selectedTimer in
            print(selectedTimer)
            self?.timerPickerView?.isTo(show: false)
        })
    }
}
