//
//  WBTabBarController.swift
//  MSProject
//
//  Created by Matias Spinelli on 10/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

class WBTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.barTintColor = .woloxTabBarBackgroundColor()
        
        let libraryTabNavigationController = WBNavigationController(rootViewController: WBLibraryTableViewController())
        libraryTabNavigationController.tabBarItem = UITabBarItem()
        libraryTabNavigationController.tabBarItem.title = "LIBRARY_NAV_BAR".localized()
        libraryTabNavigationController.tabBarItem.image = UIImage.libraryImage
        libraryTabNavigationController.tabBarItem.selectedImage = UIImage.libraryActiveImage
        libraryTabNavigationController.tabBarItem.tag = 0
        
        let wishlistNavigationController = WBNavigationController(rootViewController: WBWishlistViewController())
        wishlistNavigationController.tabBarItem = UITabBarItem()
        wishlistNavigationController.tabBarItem.title = "WISHLIST_NAV_BAR".localized()
        wishlistNavigationController.tabBarItem.image = UIImage.wishlistImage
        wishlistNavigationController.tabBarItem.image = UIImage.wishlistActiveImage
        wishlistNavigationController.tabBarItem.tag = 1

        let addnewNavigationController = WBNavigationController(rootViewController: WBAddNewViewController())
        addnewNavigationController.tabBarItem = UITabBarItem()
        addnewNavigationController.tabBarItem.title = "ADDNEW_NAV_BAR".localized()
        addnewNavigationController.tabBarItem.image = UIImage.addNewImage
        addnewNavigationController.tabBarItem.image = UIImage.addNewActiveImage
        addnewNavigationController.tabBarItem.tag = 2
        
        let rentalsNavigationController = WBNavigationController(rootViewController: WBRentalsViewController())
        rentalsNavigationController.tabBarItem = UITabBarItem()
        rentalsNavigationController.tabBarItem.title = "RENTALS_NAV_BAR".localized()
        rentalsNavigationController.tabBarItem.image = UIImage.rentalsImage
        rentalsNavigationController.tabBarItem.image = UIImage.rentalsActiveImage
        rentalsNavigationController.tabBarItem.tag = 3
        
        let settingsNavigationController = WBNavigationController(rootViewController: WBSettingsViewController())
        settingsNavigationController.tabBarItem = UITabBarItem()
        settingsNavigationController.tabBarItem.title = "SETTINGS_NAV_BAR".localized()
        settingsNavigationController.tabBarItem.image = UIImage.settingsImage
        settingsNavigationController.tabBarItem.image = UIImage.settingsActiveImage
        settingsNavigationController.tabBarItem.tag = 4
        
        viewControllers = [libraryTabNavigationController, wishlistNavigationController, addnewNavigationController, rentalsNavigationController, settingsNavigationController]
        
    }

}
