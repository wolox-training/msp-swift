//
//  WBLoginViewController.swift
//  MSProject
//
//  Created by Matias Spinelli on 07/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

class WBLoginViewController: UIViewController {

    private let _view: WBLoginView = WBLoginView.loadFromNib()!
    
    override func loadView() {
        
        _view.loginButton.reactive.controlEvents(.touchUpInside).observeValues { _ in
            self.loginWithGoogle()
        }

        view = _view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    private func loginWithGoogle() {
        let tabBarController = WBTabBarController()
        tabBarController.modalTransitionStyle = .flipHorizontal
        present(tabBarController, animated: true, completion: nil)
    }
}
