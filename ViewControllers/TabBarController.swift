//
//  TabBarController.swift
//  Image Feed
//
//  Created by MacBook on 14.01.2025.
//

import UIKit

final class TabBarController: UITabBarController {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)

        let imagesListVC = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        imagesListVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named:"Main Active"), selectedImage:nil)

        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title:"", image:UIImage(named:"Profile Active"), selectedImage:nil)

        self.viewControllers = [imagesListVC, profileVC]
    }
}
