import UIKit

final class AuthViewController: UIViewController {
    // MARK: - Private Properties
    private let oAuth2Service = OAuth2Service.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    
    // MARK: - Public Properties
    var delegate: AuthViewControllerDelegate?

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWebView" {
            guard let webVC = segue.destination as? WebViewViewController else { fatalError("Failed to prepare for ShowWebView") }
            webVC.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)

        UIBlockingProgressHUD.show()

        oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let token):
                self.oAuth2TokenStorage.token = token
                
                // Переход к таб-бару после успешной авторизации
                self.switchToTabBarController()
                
                // Уведомление делегата об успешной авторизации (если нужно)
                self.delegate?.didAuthenticate(self)
                
            case .failure:
                let alert = UIAlertController(title: "Ошибка", message: "Не удалось войти в систему", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ОК", style: .default))
                self.present(alert, animated: true)
            }
        }
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }

    // MARK: - Private Methods
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }

        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")

        window.rootViewController = tabBarController
    }
}
