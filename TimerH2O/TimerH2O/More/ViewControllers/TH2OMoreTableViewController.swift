//
//  TH2OMoreTableViewController.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 05/01/17.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import UIKit

class TH2OMoreTableViewController: UITableViewController {
    let dataSource = [R.string.localizable.moreAcknowledgements()]
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: R.segue.tH2OMoreTableViewController.acknowledgements, sender: self)
        default:
            ()
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.moreCell.identifier, for: indexPath)

        let info = dataSource[indexPath.row]
        cell.textLabel?.text = info
        
        return cell
    }
}
