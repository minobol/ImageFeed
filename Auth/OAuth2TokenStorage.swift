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
            let token = storage.string(forKey: Keys.tokenStorage.rawValue)
            return token
        }
        set {
            storage.set(newValue ?? "", forKey: Keys.tokenStorage.rawValue)
            print("Token write: \(String(describing: token))")
        }
    }
    
    private let storage = KeychainWrapper.standard
    
    private enum Keys: String {
        case tokenStorage
    }
}

