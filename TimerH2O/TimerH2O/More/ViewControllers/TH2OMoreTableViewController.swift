//
//  TH2OMoreTableViewController.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 05/01/17.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import UIKit

enum MoreDetail: Int {
    case acknowledgements
    
    case privacy
    case healthData
}

final class TH2OMoreTableViewController: UITableViewController {
    let dataSource = [R.string.localizable.moreAcknowledgements(),
                      R.string.localizable.morePrivacy(),
                      R.string.localizable.moreHealthData()]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TH2OMoreDetailViewController, let a = tableView.indexPathForSelectedRow {
            switch a.row {
            case MoreDetail.acknowledgements.rawValue:
                vc.type = MoreDetail.acknowledgements
            case MoreDetail.privacy.rawValue:
                vc.type = MoreDetail.privacy
            default:
                ()
            }
        }
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == MoreDetail.healthData.rawValue {
            performSegue(withIdentifier: R.segue.tH2OMoreTableViewController.healthData, sender: self)
        } else {
            performSegue(withIdentifier: R.segue.tH2OMoreTableViewController.webDetails, sender: self)
        }
    }
    
    // MARK: - Table view data source
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
