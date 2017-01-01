//
//  RealmManager.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 01/01/17.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmManager {
    func create(newSession session: Model) {
        let new = Session()
        new.idx = session.idx
        new.goal = session.water
        new.interval = session.interval
        new.start = Date()
        
        write(new)
    }
    
    func updateSession(withEnd end: Date) {
        do {
            // Get the default Realm
            let realm = try Realm()
            
            if let idx = SessionManager().sessionID(),
                let session = realm.object(ofType: Session.self, forPrimaryKey: idx) {
                try realm.write {
                    session.end = end
                }
            }
        } catch {}
    }
    
    func loadAllSessions() -> Results<Session>? {
        do {
            // Get the default Realm
            let realm = try Realm()
            
            return realm.objects(Session.self).sorted(byProperty: "start")
        } catch {
            return nil
        }
    }
    
    private func write(_ object: Object) {
        do {
            // Get the default Realm
            let realm = try Realm()
            
            // Add to the Realm inside a transaction
            try realm.write {
                realm.add(object)
            }
        } catch {}
    }
}