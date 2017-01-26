//
//  TH2OHistoryViewController.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 23/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit
import RealmSwift

class TH2OHistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var collection: Results<Session>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = R.string.localizable.history()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let list = RealmManager().loadAllSessions(), list.count > 0 else {
            tableView.isHidden = true
            return
        }
        
        collection = list
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TH2OHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collection?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.sessionCell.identifier, for: indexPath)
    
        cell = setup(cell: cell, forRowAt: indexPath)
        
        return cell
    }
}

extension TH2OHistoryViewController: UITableViewDelegate {
    
}

extension TH2OHistoryViewController {
    fileprivate func setup(cell: UITableViewCell, forRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let session = collection?[indexPath.row] else {
            return cell
        }
        
        let goal = R.string.localizable.historyCellGoal()
        let amount = R.string.localizable.historyCellAmount()
        cell.textLabel?.text = "\(goal): " + String(session.goal) + " \(amount): " + String(session.amount)
        
        let start = DateFormatter.localizedString(from: session.start, dateStyle: .short, timeStyle: .short)
        let end = DateFormatter.localizedString(from: session.end, dateStyle: .short, timeStyle: .short)
        let date = "\(R.string.localizable.historyCellStart()): \(start) \(R.string.localizable.historyCellEnd()): \(end)"
        cell.detailTextLabel?.text = date
        
        return cell
    }
}
