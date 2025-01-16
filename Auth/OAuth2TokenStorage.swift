//
//  OAuth2TokenStorage.swift
//  Image Feed
//
//  Created by MacBook on 27.11.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    var token: String? {
        get {
            return storage.string(forKey: Keys.tokenStorage.rawValue)
        }
        set {
            if let newValue = newValue {
                storage.set(newValue, forKey: Keys.tokenStorage.rawValue)
            } else {
                storage.removeObject(forKey: Keys.tokenStorage.rawValue)
            }
        }
    }
    
    private let storage = KeychainWrapper.standard
    
    private enum Keys: String {
        case tokenStorage
    }
}
