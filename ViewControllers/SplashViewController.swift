//
//  SplashViewController.swift
//  Image Feed
//
//  Created by MacBook on 27.11.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let profileImageService = ProfileImageService.shared
    private let profileService = ProfileService()

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Vector")
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        makeConstraints()
        view.backgroundColor = UIColor(named: "ypBlack")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if oAuth2TokenStorage.token != nil {
            switchToTabBarController()
        } else {
            switchToAuthViewController()
        }
    }

    private func addSubviews() {
        view.addSubview(logoImageView)
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }

    private func switchToAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let navigationVC = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? UINavigationController,
              let authVC = navigationVC.topViewController as? AuthViewController else { return }

        authVC.delegate = self
        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true)
    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { return }

        let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController")

        window.rootViewController = tabBarVC
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)

        guard let token = oAuth2TokenStorage.token else { return }
        
        fetchProfile(token)
    }

    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(token: token) { result in
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success:
                self.switchToTabBarController()
                self.profileImageService.fetchProfileImageUrl(token: token) { result in
                    switch result {
                    case .success:
                        print("Success avatar load")
                    case .failure(let error):
                        print("Load avatar error:", error)
                    }
                }
            case .failure(let error):
                print("Load profile error:", error)
            }
        }
    }
}
