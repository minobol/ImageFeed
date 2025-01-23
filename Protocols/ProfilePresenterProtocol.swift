//
//  File.swift
//  Image Feed
//
//  Created by MacBook on 24.11.2024.
//
import UIKit

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func updateProfile()
    func viewDidLoad()
}
