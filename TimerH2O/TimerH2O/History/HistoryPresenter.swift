//
//  HistoryPresenter.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 04/06/2017.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

protocol HistoryView: class {}

struct SessionInfo {
    let goal: String
    let amount: String
    let start: String
    let end: String
}

class HistoryPresenterImplementation {
    weak var view: HistoryView!
    private var dataWrapper: DataWrapper?
    private var sessionsList: Results<Session>?
    
    init(view: HistoryView, dataWrapper: DataWrapper = RealmManager()) {
        self.view = view
        self.dataWrapper = dataWrapper
    }
    
    func loadSessions() -> Int {
        guard let list = dataWrapper?.loadAllSessions(), list.count > 0 else {
            return 0
        }
        
        if let userId = UIDevice.current.identifierForVendor?.uuidString,
            let user = dataWrapper?.loadUser(withId: userId) {
            // Check for old final users
            for session in list where session.user == nil {
                    dataWrapper?.update(session: session, withUser: user)
            }
        }
        self.sessionsList = list
        return list.count
    }
    
    func data(forCellAt index: Int) -> SessionInfo? {
        guard let session = sessionsList?[index] else {
            return nil
        }
        
        let goal = String(session.goal)
        let amount = String(session.amount)
        let start = DateFormatter.localizedString(from: session.start, dateStyle: .short, timeStyle: .short)
        let end = DateFormatter.localizedString(from: session.end, dateStyle: .short, timeStyle: .short)
        
        return SessionInfo(goal: goal, amount: amount, start: start, end: end)
    }
}
