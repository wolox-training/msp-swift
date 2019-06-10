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

    private let settingsView: WBSettingsView = WBSettingsView.loadFromNib()!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "SETTINGS".localized()
    }
    
    override func loadView() {
        view = settingsView
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
