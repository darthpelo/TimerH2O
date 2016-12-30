//
//  TH2OSetSessionViewController.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 27/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit

class TH2OSetSessionViewController: UIViewController, Configurable, Seguible {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var waterView: UIView!
    @IBOutlet weak var waterAmountTextLabel: UILabel!
    @IBOutlet weak var waterAmountLabel: UILabel!
    @IBOutlet weak var intervalView: UIView!
    @IBOutlet weak var intervalTextLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    lazy var presenter: Presenter = Presenter(view: self)
    
    public var waterPickerView: TH2OWaterPickerView?
    public var timerPickerView: TH2OTimerPickerView?
    
    internal var water: Int?
    internal var interval: TimeInterval?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGesture()
        configureLabels()
        configureWaterPickerView()
        configureTimerPickerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AnswerManager().log(event: "SetSessionViewController")
    }

    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        backToTimer()
        AnswerManager().log(event: "CancelButtonPressed")
    }

    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        manageDoneRequest()
        AnswerManager().log(event: "DoneButtonPressed")
    }
}

extension TH2OSetSessionViewController {
    fileprivate func manageDoneRequest() {
        guard let water = self.water, let interval = self.interval else {
            return
        }
        presenter.save(model: Model(water: water, interval: interval))
        backToTimer()
    }
}
