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
    static let defaultBaseURL = URL (string: "https://api.unsplash.com/")
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let defaultURL = URL(string: "https://unsplash.com/")
    static let reuseIdentifier = "ImagesListCell"
}
