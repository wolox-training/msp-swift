//
//  WBAddNewViewController.swift
//  MSProject
//
//  Created by Matias Spinelli on 10/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

class WBAddNewViewController: UIViewController {

    private let addNewView: WBAddNewView = WBAddNewView.loadFromNib()!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "ADDNEW".localized()
    }
    
    override func loadView() {
        view = addNewView
    }

}
