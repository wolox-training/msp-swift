//
//  WBWishlistView.swift
//  MSProject
//
//  Created by Matias Spinelli on 10/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

class WBWishlistView: UIView, NibLoadable {

    @IBOutlet weak var bookTable: UITableView! {
        didSet {
            bookTable.backgroundColor = .woloxBackgroundLightColor()
            bookTable.separatorStyle = .none
        }
    }
}
