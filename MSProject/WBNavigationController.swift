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
        
        // Do any additional setup after loading the view.
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
        navigationBar.tintColor = UIColor.white
        navigationBar.barStyle = .default
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.titleTextAttributes = textAttributes
        navigationBar.backgroundColor = UIColor.woloxBackgroundColor()
        navigationBar.setBackgroundImage(UIImage(named: "bc_nav bar")!.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
        navigationBar.shadowImage = UIImage()

//        if #available(iOS 11.0, *) {
//            navigationBar.prefersLargeTitles = true
//        }
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
