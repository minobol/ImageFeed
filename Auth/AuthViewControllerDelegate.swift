//
//  AuthViewControllerDelegate.swift
//  Image Feed
//
//  Created by MacBook on 27.11.2024.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}
