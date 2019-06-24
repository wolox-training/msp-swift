//
//  WBEmptyViewController.swift
//  MSProject
//
//  Created by Matias Spinelli on 24/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

class WBEmptyViewController: UIViewController {

    private let _view: WBEmptyView = WBEmptyView.loadFromNib()!

    override func loadView() {
        view = _view
    }
}
