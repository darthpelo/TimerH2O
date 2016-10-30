//
//  TH2OPickerView.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 29/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit

class TH2OPickerView: UIView {

    @IBOutlet weak var pickerTitleLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var doneButton: UIButton!
    
    fileprivate let numbers = (0...9).map{"\($0)"}
    fileprivate var amount = ["0","0","0"]
    
    typealias DoneAmount = (Int) -> ()
    typealias DoneTimeInterval = (Double) -> ()
    
    fileprivate var doneAmount: DoneAmount?
    private var parentView: UIView?
    
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        guard let a = convert(amount: amount) else {
            return
        }
        doneAmount?(a)
    }
    
    func loaPickerView() -> TH2OPickerView? {
        guard let view = R.nib.tH2OPickerView.firstView(owner: self) else {
            return nil
        }
        
        view.frame.origin.y = UIScreen.main.bounds.height
        view.frame.size.width = UIScreen.main.bounds.width
        return view
    }
    
    func configure(onView:UIView, withCallback: @escaping DoneAmount) {
        doneAmount = withCallback
        parentView = onView
        self.frame.origin.y = onView.frame.size.height
        
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    func pickerView(isToShow show: Bool) {
        UIView.animate(withDuration:0.3,
                       animations: { [weak self] in
                        if show {
                            self?.frame.origin.y = self!.parentView!.center.y
                        } else {
                            self?.frame.origin.y = self!.parentView!.frame.size.height
                        }
            },completion: nil)
    }
    
    private func convert(amount: [String]) -> Int? {
        var result: String = ""
        for c in amount {
            result = result + c
        }
        return Int(result)
    }
}

extension TH2OPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
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
