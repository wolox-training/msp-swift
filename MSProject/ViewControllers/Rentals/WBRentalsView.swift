//
//  WBRentalsView.swift
//  MSProject
//
//  Created by Matias Spinelli on 10/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

class WBRentalsView: UIView, NibLoadable {

    @IBOutlet weak var bookTable: UITableView!
    
    func configureLibraryTableView() {
        bookTable.backgroundColor = .woloxBackgroundLightColor()
        bookTable.separatorStyle = .none
    }
}
