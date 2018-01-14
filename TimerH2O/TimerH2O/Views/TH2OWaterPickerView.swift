//
//  TH2OWaterPickerView.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 29/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit

class TH2OWaterPickerView: UIView {

    @IBOutlet weak var pickerTitleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    fileprivate let numbers = (0...9).map {"\($0)"}
    fileprivate var amount = ["0", "0", "0", "0"]
    
    typealias DoneAmount = (Int) -> Void
    
    fileprivate var doneAmount: DoneAmount?
    private var parentView: UIView?
    
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        guard let amount = Converter.convert(amount: amount) else {
            return
        }
        doneAmount?(amount)
    }
    
    func loadPickerView() -> TH2OWaterPickerView? {
        guard let view = R.nib.th2OWaterPickerView.firstView(owner: self) else {
            return nil
        }
        
        view.frame.origin.y = UIScreen.main.bounds.height
        view.frame.size.width = UIScreen.main.bounds.width
        return view
    }
    
    func configure(onView: UIView, withCallback: @escaping DoneAmount) {
        doneAmount = withCallback
        parentView = onView
        self.frame.origin.y = onView.frame.size.height
        
        pickerTitleLabel.text = R.string.localizable.setsessionWaterpickerTitle()
        doneButton.setTitle(R.string.localizable.done(), for: .normal)
        
        pickerView.selectRow(2, inComponent: 0, animated: false)
        amount[0] = "2"
        
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    func isTo(show: Bool) {
        guard let height = parentView?.frame.size.height else {
            return
        }
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        if show {
                            self.frame.origin.y = height - self.frame.size.height
                        } else {
                            self.frame.origin.y = height
                        }
            }, completion: nil)
    }
}

extension TH2OWaterPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
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
