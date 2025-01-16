//
//  SplashViewController.swift
//  Image Feed
//
//  Created by MacBook on 27.11.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Private Properties
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Vector")
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        makeConstraints()
        view.backgroundColor = UIColor(named: "ypBlack")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Проверяем наличие и валидность токена
        checkAndSwitchToAppropriateController()
    }
    
    // MARK: - Private Methods
    private func addSubviews() {
        [logoImageView].forEach { [weak self] in
            $0.translatesAutoresizingMaskIntoConstraints = false
            self?.view.addSubview($0)
        }
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func switchToAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let navigationController =
                storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? UINavigationController,
              let authViewController =
                navigationController.topViewController as? AuthViewController else { return }

        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true, completion: nil)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }

        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")

        window.rootViewController = tabBarController
    }

    // MARK: - Token Validation and Switching
    private func checkAndSwitchToAppropriateController() {
        if let token = oAuth2TokenStorage.token, isValidToken(token) {
            switchToTabBarController() // Переход к основному экрану
        } else {
            switchToAuthViewController() // Переход к экрану аутентификации
        }
    }

    private func isValidToken(_ token: String) -> Bool {
        // Проверяем, что длина токена больше 40 символов
        return token.count > 40
    }
}
