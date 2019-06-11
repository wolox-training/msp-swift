//
//  WBWishlistViewController.swift
//  MSProject
//
//  Created by Matias Spinelli on 10/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

class WBWishlistViewController: UIViewController {

    private let wishlistView: WBWishlistView = WBWishlistView.loadFromNib()!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "WISHLIST".localized()
    }
    
    override func loadView() {
        view = wishlistView
    }

}
