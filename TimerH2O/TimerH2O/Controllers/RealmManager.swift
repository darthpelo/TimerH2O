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
    enum EncryptionError: Error {
        case Empty
    }
    
    //MARK: - Public
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
    
    func loadAllSessions() -> Results<Session>? {
        do {
            // Get the default Realm
            let realm = try loadRealm()
            
            return realm.objects(Session.self).filter("start != end").sorted(byProperty: "start", ascending: false)
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
    
    //MARK: - Private
    private func loadRealm() throws -> Realm {
        let configuration = Realm.Configuration(encryptionKey: try getKey())
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

    private func getKey() throws -> Data {
        // Identifier for our keychain entry - should be unique for your application
        let keychainIdentifier = "com.alessioroberto.EncryptionExampleKey"
        guard let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            throw EncryptionError.Empty
        }
        
        // First check in the keychain for an existing key
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]
        
        // To avoid Swift optimization bug, should use withUnsafeMutablePointer() function to retrieve the keychain item
        // See also: http://stackoverflow.com/questions/24145838/querying-ios-keychain-using-swift/27721328#27721328
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data {
                return data
            } else {
                throw EncryptionError.Empty
            }
        }
        
        // No pre-existing key from this application, so generate a new one
        guard let keyData = NSMutableData(length: 64) else {
            throw EncryptionError.Empty
        }
        
        let result = SecRandomCopyBytes(kSecRandomDefault, 64, keyData.mutableBytes.bindMemory(to: UInt8.self, capacity: 64))
        assert(result == 0, "Failed to get random bytes")
        
        // Store the key in the keychain
        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecValueData: keyData
        ]
        
        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
        
        return keyData as Data
    }
}
