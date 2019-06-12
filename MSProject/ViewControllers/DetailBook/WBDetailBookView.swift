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
    
    @IBOutlet weak var detailTableView: UITableView!
    
    func configureDetailTableView() {
        detailTableView.backgroundColor = UIColor.woloxBackgroundLightColor()
        detailTableView.separatorStyle = .none
        
    }
}
