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

        tabBar.barTintColor = UIColor.woloxTabBarBackgroundColor()
        
        let libraryTabNavigationController = WBNavigationController(rootViewController: WBLibraryTableViewController())
        libraryTabNavigationController.tabBarItem = UITabBarItem()
        libraryTabNavigationController.tabBarItem.title = "LIBRARY".localized()
        libraryTabNavigationController.tabBarItem.image = UIImage(named: "ic_library")
        libraryTabNavigationController.tabBarItem.selectedImage = UIImage(named: "ic_library active")
        libraryTabNavigationController.tabBarItem.tag = 0
        
        let wishlistNavigationController = WBNavigationController(rootViewController: WBWishlistViewController())
        wishlistNavigationController.tabBarItem = UITabBarItem()
        wishlistNavigationController.tabBarItem.title = "WISHLIST".localized()
        wishlistNavigationController.tabBarItem.image = UIImage(named: "ic_wishlist")
        wishlistNavigationController.tabBarItem.image = UIImage(named: "ic_wishlist active")
        wishlistNavigationController.tabBarItem.tag = 1

        let addnewNavigationController = WBNavigationController(rootViewController: WBAddNewViewController())
        addnewNavigationController.tabBarItem = UITabBarItem()
        addnewNavigationController.tabBarItem.title = "ADDNEW".localized()
        addnewNavigationController.tabBarItem.image = UIImage(named: "ic_add new")
        addnewNavigationController.tabBarItem.image = UIImage(named: "ic_add new active")
        addnewNavigationController.tabBarItem.tag = 2
        
        let rentalsNavigationController = WBNavigationController(rootViewController: WBRentalsViewController())
        rentalsNavigationController.tabBarItem = UITabBarItem()
        rentalsNavigationController.tabBarItem.title = "RENTALS".localized()
        rentalsNavigationController.tabBarItem.image = UIImage(named: "ic_myrentals")
        rentalsNavigationController.tabBarItem.image = UIImage(named: "ic_myrentals active")
        rentalsNavigationController.tabBarItem.tag = 3
        
        let settingsNavigationController = WBNavigationController(rootViewController: WBSettingsViewController())
        settingsNavigationController.tabBarItem = UITabBarItem()
        settingsNavigationController.tabBarItem.title = "SETTINGS".localized()
        settingsNavigationController.tabBarItem.image = UIImage(named: "ic_settings")
        settingsNavigationController.tabBarItem.image = UIImage(named: "ic_settings active")
        settingsNavigationController.tabBarItem.tag = 4
        
        viewControllers = [libraryTabNavigationController, wishlistNavigationController, addnewNavigationController, rentalsNavigationController, settingsNavigationController]
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
