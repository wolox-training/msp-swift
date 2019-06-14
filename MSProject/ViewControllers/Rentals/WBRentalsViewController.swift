//
//  WBRentalsViewController.swift
//  MSProject
//
//  Created by Matias Spinelli on 10/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

class WBRentalsViewController: UIViewController {

    private let _view: WBRentalsView = WBRentalsView.loadFromNib()!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "RENTALS_NAV_BAR".localized()
    }
    
    override func loadView() {
        view = _view
    }

}
