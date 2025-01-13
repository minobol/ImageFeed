//
//  WebViewViewControllerDelegate.swift
//  Image Feed
//
//  Created by MacBook on 27.11.2024.
//

import UIKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
