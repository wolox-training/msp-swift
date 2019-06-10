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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
