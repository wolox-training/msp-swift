//
//  WBDetailBookView.swift
//  MSProject
//
//  Created by Matias Spinelli on 11/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

class WBDetailBookView: UIView, NibLoadable {

    @IBOutlet weak var bookImageView: UIImageView!
    
    @IBOutlet weak var detailTable: UITableView!
    
    func configureDetailTableView() {
        detailTable.backgroundColor = .woloxBackgroundLightColor()
        detailTable.separatorStyle = .none
        
        let nib = UINib.init(nibName: "WBDetailBookTableViewCell", bundle: nil)
        detailTable.register(nib, forCellReuseIdentifier: "WBDetailBookTableViewCell")
    }
}
