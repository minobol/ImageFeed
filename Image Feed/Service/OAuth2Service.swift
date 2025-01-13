//
//  OAuth2Service.swift
//  Image Feed
//
//  Created by MacBook on 27.11.2024.
//

//import Foundation
//import WebKit
//import ProgressHUD
//
////struct OAuthTokenResponseBody: Decodable {
////    let accessToken: String
////}
//
//final class OAuth2Service {
//    
//
//    private let urlSession = URLSession.shared //
//    
//    private var task: URLSessionTask?
//    private var lastCode: String?
//    
//    static let shared = OAuth2Service()
//    private init() {}
//    
//    func fetchOAuthToken(code: String, completion: @escaping (_ result: Result<String, Error>) -> Void) {
//        guard let tokenRequest = makeOAuthTokenRequest(code: code) else {
//            print("Failed to create token request.")
//            completion(.failure(NSError(domain: "OAuth2ServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to create token request."])))
//            return
//        }
//        
//        let task = URLSession.shared.data(for: tokenRequest) { result in
//            switch result {
//            case .success(let data):
//                do {
//                    // Create the decoder within the do block
//                    let decoder = JSONDecoder()
//                    decoder.keyDecodingStrategy = .convertFromSnakeCase
//                    
//                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
//                    completion(.success(response.accessToken))
//                    print("Success: \(response.accessToken)")
//                } catch {
//                    print("Error decoding response: \(error)")
//                    completion(.failure(error))
//                }
//            case .failure(let error):
//                print("Network error: \(error)")
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
//    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
//           guard let baseURL = URL(string: "https://unsplash.com") else {
//               print("Unable to construct baseURL")
//               return nil
//           }
//           
//           guard let url = URL(
//               string: "/oauth/token"
//               + "?client_id=\(Constants.accessKey)"
//               + "&&client_secret=\(Constants.secretKey)"
//               + "&&redirect_uri=\(Constants.redirectURI)"
//               + "&&code=\(code)"
//               + "&&grant_type=authorization_code",
//               relativeTo: baseURL
//           ) else {
//               print("Unable to construct URL with provided parameters.")
//               return nil
//           }
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        return request
//    }
//}
//

import Foundation
import WebKit
import ProgressHUD

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    // MARK: - Private Properties
    private init() {}
    private var task: URLSessionTask?
    private var lastCode: String?
    
    // MARK: - fetchOAuthToken func
    func fetchOAuthToken(code: String, handler: @escaping (_ result: Result<String, Error>) -> Void) {
        guard let tokenRequest = makeOAuthTokenRequest(code: code)
        else {
            return
        }
        
        assert(Thread.isMainThread)
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                handler(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                handler(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        lastCode = code
        
        let task = URLSession.shared.objectTask(for: tokenRequest) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { preconditionFailure("") }
            self.task = nil
            self.lastCode = nil
            switch result {
            case .success(let data):
                UIBlockingProgressHUD.dismiss()
                print("Success token: \(data.accessToken)")
                handler(.success(data.accessToken))
            case .failure(let error):
                print("Error: \(handler(.failure(error)))")
                handler(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

// MARK: - makeOAuthTokenRequest private func
private func makeOAuthTokenRequest(code: String) -> URLRequest? {
    guard let baseURL = Constants.defaultURL
    else {
        preconditionFailure("Unable to construct baseURL")
    }
    guard let url = URL(
        string: "/oauth/token"
        + "?client_id=\(Constants.accessKey)"
        + "&&client_secret=\(Constants.secretKey)"
        + "&&redirect_uri=\(Constants.redirectURI)"
        + "&&code=\(code)"
        + "&&grant_type=authorization_code",
        relativeTo: baseURL
    ) else {
        preconditionFailure("Unable to construct url")
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    print("Token request: \(request)")
    return request
}

// MARK: - Models
enum AuthServiceError: Error {
    case invalidRequest
}

struct OAuthTokenResponseBody: Codable {
    var accessToken: String
}
