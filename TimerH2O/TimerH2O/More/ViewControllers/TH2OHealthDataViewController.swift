//
//  TH2OHealthDataViewController.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 22/01/2017.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import UIKit

final class TH2OHealthDataViewController: UIViewController, Configurable {
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var switchLabel: UILabel!

    @IBOutlet weak var healthSwitch: UISwitch!

    private let healthManager = HealthManager()
    lazy var presenter: HealthPresenter = HealthPresenter(healthManager: self.healthManager)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        healthSwitch.isOn = presenter.healthKitIsAuthorized()
        
        if presenter.healthKitIsAuthorized() {
            healthSwitch.isHidden = true
            switchLabel.isHidden = true
        }
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        presenter.healthKitAuthorize { [weak self] (authorize) in
            self?.healthSwitch.isOn = authorize
            
            if authorize { AnswerManager().log(event: "Health Connected") }
        }
    }
}
