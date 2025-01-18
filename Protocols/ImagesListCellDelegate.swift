//
//  ImagesListCellDelegate.swift
//  Image Feed
//
//  Created by MacBook on 18.01.2025.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
