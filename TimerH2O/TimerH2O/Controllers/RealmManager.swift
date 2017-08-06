//
//  RealmManager.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 01/01/17.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import Foundation
import RealmSwift

protocol DataWrapper {
    func create(newUser userId: String)
    func create(newSession session: Model)
    func updateSession(withEnd end: Date, finalAmount amount: Double)
    func update(session: Session, withUser user: Person)
    func loadAllSessions() -> Results<Session>?
    func loadSession(withId idx: String) -> Session?
    func loadUser(withId userId: String) -> Person?
}

struct RealmManager: DataWrapper {
    // MARK: - Public
    func create(newUser userId: String) {
        let new = Person()
        new.userId = userId
        
        write(new)
    }
    
    func create(newSession session: Model) {
        let new = Session()
        new.idx = session.idx
        new.goal = session.water
        new.interval = session.interval
        new.start = Date()
        new.end = new.start
        
        write(new)
    }
    
    func updateSession(withEnd end: Date, finalAmount amount: Double) {
        do {
            // Get the default Realm
            let realm = try loadRealm()
            
            if let idx = SessionManager().sessionID(),
                let session = realm.object(ofType: Session.self, forPrimaryKey: idx) {
                try realm.write {
                    session.amount = session.goal - amount
                    session.end = end
                }
            }
        } catch {
            log(text: "Open with wrong key: \(error)")
        }
    }
    
    func update(session: Session, withUser user: Person) {
        do {
            let realm = try loadRealm()
            
            try realm.write {
                session.user = user
            }
        } catch {
            log(text: "Realm error: \(error)")
        }
    }
    
    func loadAllSessions() -> Results<Session>? {
        do {
            // Get the default Realm
            let realm = try loadRealm()
            
            return realm.objects(Session.self).filter("start != end").sorted(byKeyPath: "start", ascending: false)
        } catch {
            log(text: "Open with wrong key: \(error)")
            return nil
        }
    }
    
    func loadSession(withId idx: String) -> Session? {
        do {
            // Get the default Realm
            let realm = try loadRealm()
            
            return realm.object(ofType: Session.self, forPrimaryKey: idx)
        } catch {
            log(text: "Open with wrong key: \(error)")
            return nil
        }
    }
    
    func loadUser(withId userId: String) -> Person? {
        do {
            // Get the default Realm
            let realm = try loadRealm()
            
            let predicate = NSPredicate(format:"userId = %@", userId)
            return realm.objects(Person.self).filter(predicate).first
        } catch {
            log(text: "Open with wrong key: \(error)")
            return nil
        }
    }
    
    // MARK: - Private
    private func loadRealm() throws -> Realm {
        let migrationBlock: MigrationBlock = { migration, oldSchemaVersion in
            migration.enumerateObjects(ofType: Person.className(), { (_, newObject) in
                if oldSchemaVersion < 1 {
                    newObject?["userId"] = ""
                    newObject?["emailAddress"] = ""
                }
            })
        }
        
        let configuration = Realm.Configuration(encryptionKey: try getKey(), schemaVersion: 1, migrationBlock: migrationBlock)
        let realm = try Realm(configuration: configuration)
        return realm
    }
    
    private func write(_ object: Object) {
        do {
            // Get the default Realm
            let realm = try loadRealm()
            
            // Add to the Realm inside a transaction
            try realm.write {
                realm.add(object)
            }
        } catch {
            log(text: "Open with wrong key: \(error)")
        }
    }
    
    private func log(text: String) {
        print(text + "\n\n")
    }
}
