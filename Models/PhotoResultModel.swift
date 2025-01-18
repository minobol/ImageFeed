//
//  PhotoResultModel.swift
//  Image Feed
//
//  Created by MacBook on 18.01.2025.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
}
