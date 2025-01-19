//
//  ProfileLogoutService.swift
//  Image Feed
//
//  Created by MacBook on 18.01.2025.
//

import UIKit
import WebKit

final class ProfileLogoutService {
    // MARK: - Private Properties
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let splashViewController = SplashViewController.shared
    private let imagesListService = ImagesListService.shared
    
    
    static let shared = ProfileLogoutService()
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Methods
    func logout() {
        oAuth2TokenStorage.token = nil
        switchToSplashViewController()
        imagesListService.ImagesListServicePhotosClean()
     }
    
    private func switchToSplashViewController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        window.rootViewController = SplashViewController()
    }
}
