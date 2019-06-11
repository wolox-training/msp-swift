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

    private let rentalsView: WBRentalsView = WBRentalsView.loadFromNib()!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "RENTALS".localized()
    }
    
    override func loadView() {
        view = rentalsView
    }

}
