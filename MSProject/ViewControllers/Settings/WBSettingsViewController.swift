//
//  WBSettingsViewController.swift
//  MSProject
//
//  Created by Matias Spinelli on 10/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

class WBSettingsViewController: UIViewController {

    private let _view: WBSettingsView = WBSettingsView.loadFromNib()!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "SETTINGS_NAV_BAR".localized()
    }
    
    override func loadView() {
        view = _view
    }

}
