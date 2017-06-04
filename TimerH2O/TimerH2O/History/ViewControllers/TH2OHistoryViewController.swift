//
//  TH2OHistoryViewController.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 23/10/16.
//  Copyright © 2016 Alessio Roberto. All rights reserved.
//

import UIKit

class TH2OHistoryViewController: UIViewController, HistoryView {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var collectionElements: Int?
    
    lazy var presenter: HistoryPresenterImplementation = HistoryPresenterImplementation(view: self)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }

}

extension TH2OHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionElements ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.sessionCell.identifier, for: indexPath)
    
        cell = setup(cell: cell, forRowAt: indexPath)
        
        return cell
    }
}

extension TH2OHistoryViewController: UITableViewDelegate {}

extension TH2OHistoryViewController {
    fileprivate func setupUI() {
        self.title = R.string.localizable.history()
        
        collectionElements = presenter.loadSessions()
        
        if let collection = collectionElements, collection > 0 {
            tableView.isHidden = false
        } else {
            tableView.isHidden = true
        }
        
        tableView.reloadData()
    }
    
    fileprivate func setup(cell: UITableViewCell, forRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let session = presenter.data(forCellAt: indexPath.row) else { return cell }
        
        let goal = R.string.localizable.historyCellGoal()
        let amount = R.string.localizable.historyCellAmount()
        cell.textLabel?.text = "\(goal): " + session.goal + " \(amount): " + session.amount
        
        let date = "\(R.string.localizable.historyCellStart()): \(session.start) \(R.string.localizable.historyCellEnd()): \(session.end)"
        cell.detailTextLabel?.text = date
        
        return cell
    }
}
