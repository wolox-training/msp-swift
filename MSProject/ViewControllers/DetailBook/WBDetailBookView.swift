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
    
    @IBOutlet weak var detailTable: UITableView! {
        didSet {
            detailTable.backgroundColor = .clear
            detailTable.separatorStyle = .none
            detailTable.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var detailHeaderView: WBDetailBookHeaderView!

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .woloxBackgroundLightColor()
    }
}
