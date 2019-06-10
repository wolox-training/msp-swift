//
//  WBLoginViewController.swift
//  MSProject
//
//  Created by Matias Spinelli on 07/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

class WBLoginViewController: UIViewController {

    private let loginView: WBLoginView = WBLoginView.loadFromNib()!
    
    override func loadView() {
        loginView.delegate = self
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    @IBAction func loginWithGoogle(_ sender: Any) {
        let tabBarController = WBTabBarController()
        tabBarController.modalTransitionStyle = .flipHorizontal
        present(tabBarController, animated: true, completion: nil)
    }
}
