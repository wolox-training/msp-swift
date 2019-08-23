//
//  WBNavigationController.swift
//  MSProject
//
//  Created by Matias Spinelli on 10/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

class WBNavigationController: UINavigationController {

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        woloxBookInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        woloxBookInit()
    }
    
    // MARK: - Private
    private func woloxBookInit() {
        navigationBar.isTranslucent = true
        navigationBar.tintColor = .white
        navigationBar.barStyle = .default
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.titleTextAttributes = textAttributes
        navigationBar.backgroundColor = .woloxBackgroundLightColor()
        navigationBar.barTintColor = .woloxBackgroundLightColor()

        navigationBar.setBackgroundImage(UIImage.navBarImage.resizableImage(withCapInsets: .zero, resizingMode: .stretch), for: .default)
        navigationBar.shadowImage = UIImage()
        
        let backImage = UIImage.backImage
        navigationBar.backIndicatorImage = backImage
        navigationBar.backIndicatorTransitionMaskImage = backImage
        
        // common configuration
        if let viewController = viewControllers.first {
            let logout = UIBarButtonItem(image: UIImage.logoutImage, style: .plain, target: self, action: #selector(self.logout))
            viewController.navigationItem.leftBarButtonItem = logout
        }
    }
    
    @objc private func logout() {
        dismiss(animated: true, completion: nil)
    }

}
