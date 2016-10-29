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
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerViewTop: NSLayoutConstraint!
    
    fileprivate let numbers = (0...9).map{"\($0)"}
    fileprivate var amount = ["0","0","0"]
    
    lazy var presenter: Presenter = Presenter(view: self)
    
    enum PickerTop: CGFloat {
        case show = 8
        case hide = 600
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerViewTop.constant =  PickerTop.hide.rawValue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapWaterView))
        tap.delegate = self
        waterView.addGestureRecognizer(tap)
    }

    
    @IBAction func pickerDonePressed(_ sender: AnyObject) {
        pickerViewTop.constant = PickerTop.hide.rawValue
        guard let value = convert(amount: amount) else {
            return
        }
        waterAmountLabel.text = "\(value)cl"
    }
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        self.performSegue(withIdentifier: R.segue.tH20SetSessionViewController.backToTimerVC, sender: self)
    }

}

extension TH20SetSessionViewController: UIGestureRecognizerDelegate {
    func handleTapWaterView() {
        pickerViewTop.constant = PickerTop.show.rawValue
    }
}

extension TH20SetSessionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return numbers[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        amount[component] = numbers[row]
    }
}

extension TH20SetSessionViewController: ViewProtocol {
    
}
