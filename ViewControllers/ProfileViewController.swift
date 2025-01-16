//
//  ProfilViewController.swift
//  Image Feed
//
//  Created by MacBook on 18.11.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController, AuthViewControllerDelegate {
    
    // MARK: - Private Properties
    private let profileService = ProfileService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder.jpeg")
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ypWhite")
        label.font = UIFont.boldSystemFont(ofSize: 23.0)
        return label
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ypGrey")
        label.font = UIFont.systemFont(ofSize: 13.0)
        return label
    }()
    
    private let profileDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ypWhite")
        label.font = UIFont.systemFont(ofSize: 13.0)
        return label
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ipad.and.arrow.forward")!, for: .normal)
        button.addTarget(nil, action: #selector(didTapExitProfileButton), for: .touchUpInside)
        button.tintColor = UIColor(named: "ypRed")
        return button
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        makeConstraints()
        
        guard let token = oAuth2TokenStorage.token else {
            print("token error ")
            return
        }
        
        DispatchQueue.main.async {
            self.profileService.fetchProfile(token: token) { result in
                self.updateProfileDetails()
                self.profileImageService.fetchProfileImageUrl(token: token) { result in
                    switch result {
                    case .success:
                        print("Success avatar load")
                    case .failure:
                        print("Load avatar error")
                        break
                    }
                }
            }
            
            self.profileImageServiceObserver = NotificationCenter.default
                .addObserver(
                    forName: ProfileImageService.didChangeNotification,
                    object: nil,
                    queue: .main
                ) { [weak self] _ in
                    guard let self = self else { return }
                    self.updateAvatar()
                }
            self.updateAvatar()
        }
    }
    
    // MARK: - AuthViewControllerDelegate
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        guard let token = oAuth2TokenStorage.token else {
            print("token error ")
            return
        }
        
        fetchProfile(token)
    }
    
    // MARK: - Private Methods
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(token: token) { result in
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success:
                self.updateProfileDetails()
                print("Success authenticate")
            case .failure:
                print("Load profile error")
                break
            }
        }
        
        profileImageService.fetchProfileImageUrl(token: token) { result in
            switch result {
            case .success:
                print("Success avatar load")
            case .failure:
                print("Load avatar error")
                break
            }
        }
    }

    private func updateProfileDetails() {
        if let profile = profileService.profile {
            nameLabel.text = profile.name
            nickNameLabel.text = "@\(profile.username)"
            profileDescriptionLabel.text = profile.bio
        } else {
            print("No profile found")
        }
    }

    private func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.avatarURL else { return }
        
        let imageUrl = URL(string: profileImageURL)
        
        profileImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholder.jpeg")) { result in
            
            switch result {
            case .success(let value):
                print("Kingfisher success")
                print(value.image)
                print(value.cacheType)
                print(value.source)
            case .failure(let error):
                print(error)
            }
            
            // Применяем закругление углов к изображению профиля
            let processor = RoundCornerImageProcessor(cornerRadius: 16)
            self.profileImageView.kf.indicatorType = .activity
            
            self.profileImageView.kf.setImage(with: imageUrl,
                                               placeholder: UIImage(named: "placeholder.jpeg"),
                                               options: [.processor(processor)])
            
            // Настройки кэша изображения
            let cache = ImageCache.default
            cache.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024 // 50 MB limit for memory cache
        }
    }

    private func addSubviews() {
        [
            profileImageView,
            nameLabel,
            nickNameLabel,
            profileDescriptionLabel,
            exitButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            
            nickNameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            nickNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            profileDescriptionLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            profileDescriptionLabel.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 8),
            
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
    }

    @objc
    private func didTapExitProfileButton() {
        // Удаление токена из хранилища при выходе из профиля
        oAuth2TokenStorage.token = nil
        
        // Переход к экрану аутентификации после выхода из профиля
        switchToAuthViewController()
    }

    private func switchToAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let navigationController =
                storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? UINavigationController,
              let authViewController =
                navigationController.topViewController as? AuthViewController else { return }
        
        authViewController.delegate = self // Устанавливаем делегата для аутентификации
        
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true, completion: nil)
    }
}
