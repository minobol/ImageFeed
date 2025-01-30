//
//  Constants.swift
//  Image Feed
//
//  Created by MacBook on 24.11.2024.
//

import Foundation

enum Constants {
    static let accessKey = "wsdzlJJAgmWg-HakW7f0Iyr-YOQCrSUTD_D6uiy7J9w"
    static let secretKey = "yB_wxA1xYDHqZmlwxRI854HpOYrNG-nrOAsvkpwfgrI"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL (string: "https://api.unsplash.com/")  ?? URL(fileURLWithPath: "")
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let defaultURL = URL(string: "https://unsplash.com/")
    static let reuseIdentifier = "ImagesListCell"
    static let showSingleImageSegueIdentifier = "ShowSingleImage"
    static let authViewControllerIdentifier = "ShowAuthView"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String

    static var standard: AuthConfiguration {
        .init(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            defaultBaseURL: Constants.defaultBaseURL,
            authURLString: Constants.unsplashAuthorizeURLString)
        }
}
