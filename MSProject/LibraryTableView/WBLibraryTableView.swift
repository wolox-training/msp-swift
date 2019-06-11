//
//  WBLibraryTableView.swift
//  MSProject
//
//  Created by Matias Spinelli on 10/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

class WBLibraryTableView: UIView, NibLoadable {

    @IBOutlet weak var libraryTableView: UITableView!
    
    func configureLibraryTableView() {
        libraryTableView.backgroundColor = UIColor.woloxBackgroundLightColor()
        libraryTableView.separatorStyle = .none
        
        let nib = UINib.init(nibName: "WBBookTableViewCell", bundle: nil)
        libraryTableView.register(nib, forCellReuseIdentifier: "WBBookTableViewCell")
    }
}
