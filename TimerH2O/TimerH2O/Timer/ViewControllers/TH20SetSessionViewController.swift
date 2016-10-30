//
//  TH20SetSessionViewController.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 27/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit

class TH20SetSessionViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var waterView: UIView!
    @IBOutlet weak var waterAmountLabel: UILabel!
    @IBOutlet weak var intervalView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    lazy var presenter: Presenter = Presenter(view: self)
    
    var waterPickerView: TH2OPickerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapWaterView))
        tap.delegate = self
        waterView.addGestureRecognizer(tap)
        
        configureWaterPickerView()
    }

    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        self.performSegue(withIdentifier: R.segue.tH20SetSessionViewController.backToTimerVC, sender: self)
    }

    private func configureWaterPickerView() {
        waterPickerView = TH2OPickerView().loaPickerView()
        waterPickerView?.configure(onView: self.view, withCallback: { [weak self] selectedAmount in
            self?.waterAmountLabel.text = "\(selectedAmount)cl"
            self?.waterPickerView?.pickerView(isToShow: false)
        })
    }
}
