//
//  WebViewPresenterProtocol.swift
//  Image Feed
//
//  Created by MacBook on 24.11.2024.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func code(from url: URL) -> String?
    func didUpdateProgressValue(_ newValue: Double)
}
