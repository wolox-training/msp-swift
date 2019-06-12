//
//  WBNavigationController.swift
//  MSProject
//
//  Created by Matias Spinelli on 10/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

class WBNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
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
    
    private func woloxBookInit() {
        navigationBar.isTranslucent = true
        navigationBar.tintColor = .white
        navigationBar.barStyle = .default
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.titleTextAttributes = textAttributes
        navigationBar.backgroundColor = .woloxBackgroundLightColor()
        navigationBar.setBackgroundImage(UIImage(named: "bc_nav bar")!.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
        navigationBar.shadowImage = UIImage()
        
        let backImage = UIImage(named: "ic_back")
        navigationBar.backIndicatorImage = backImage
        navigationBar.backIndicatorTransitionMaskImage = backImage

    }

}
