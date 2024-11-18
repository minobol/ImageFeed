//
//  ProfilViewController.swift
//  Image Feed
//
//  Created by MacBook on 18.11.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var loginNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var logoutButton: UIButton!
    
    @IBAction func didTapLogoutButton() {
    }
}
