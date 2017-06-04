//
//  Encrypt.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 04/01/17.
//
////////////////////////////////////////////////////////////////////////////
//
// Copyright 2014 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

import Foundation

enum EncryptionError: Error {
    case empty
}

func getKey() throws -> Data {
    guard let keychainIdentifierData = TH2OConstants.Keychain.keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
        throw EncryptionError.empty
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
            throw EncryptionError.empty
        }
    }
    
    // No pre-existing key from this application, so generate a new one
    guard let keyData = NSMutableData(length: 64) else {
        throw EncryptionError.empty
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
