import UIKit
import ProgressHUD

final class AuthViewController: UIViewController {
    private let oAuth2Service = OAuth2Service.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    
    weak var delegate: AuthViewControllerDelegate?
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == ShowWebViewSegueIdentifier {
                guard
                    let webViewViewController = segue.destination as? WebViewViewController
                else {
                    fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)")
                }
                webViewViewController.delegate = self
            } else {
                super.prepare(for: segue, sender: sender)
            }
        }
    }

//extension AuthViewController: WebViewViewControllerDelegate {
//    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
//        vc.dismiss(animated: true)
//        
//        ProgressHUD.animate()
//        oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
//            guard let self else { return }
//            
//            ProgressHUD.dismiss()
//            
//            switch result {
//            case .success(let token):
//                self.oAuth2TokenStorage.token = token
//                self.delegate?.didAuthenticate(self)
//            case .failure(let error):
//                print("Authorization error \(error)")
//            }
//        }
//    }
//    
//    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
//        dismiss(animated: true)
//    }
//}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        UIBlockingProgressHUD.show()
        oAuth2Service.fetchOAuthToken(code: code) { [self] result in
            switch result {
            case .success(let token):
                oAuth2TokenStorage.token = token
                delegate?.didAuthenticate(self)
            case .failure(_):
                let alert = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось войти в систему", preferredStyle: .alert)
                present(alert, animated: true)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    alert.dismiss(animated: false)
                }))
                present(alert, animated: true)
                print("Authorization error")
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
