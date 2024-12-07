//
//  OAuth2Service.swift
//  Image Feed
//
//  Created by MacBook on 27.11.2024.
//

import Foundation
import WebKit

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    
    func fetchOAuthToken(code: String, completion: @escaping (_ result: Result<String, Error>) -> Void) {
        guard let tokenRequest = makeOAuthTokenRequest(code: code) else {
            print("Failed to create token request.")
            completion(.failure(NSError(domain: "OAuth2ServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to create token request."])))
            return
        }
        
        let task = URLSession.shared.data(for: tokenRequest) { result in
            switch result {
            case .success(let data):
                do {
                    // Create the decoder within the do block
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(response.accessToken))
                    print("Success: \(response.accessToken)")
                } catch {
                    print("Error decoding response: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Network error: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
           guard let baseURL = URL(string: "https://unsplash.com") else {
               print("Unable to construct baseURL")
               return nil
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
               print("Unable to construct URL with provided parameters.")
               return nil
           }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}


