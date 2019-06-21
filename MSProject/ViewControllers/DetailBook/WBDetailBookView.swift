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
    
    @IBOutlet weak var detailTable: UITableView!
    
    @IBOutlet weak var detailHeaderView: WBDetailBookHeaderView!

    func configureDetailTableView() {
        
        backgroundColor = .woloxBackgroundLightColor()
        detailTable.backgroundColor = .clear
        detailTable.separatorStyle = .none
        
        detailTable.layer.cornerRadius = 5
        
        let commentBookNib = UINib.init(nibName: "WBCommentsBookTableViewCell", bundle: nil)
        detailTable.register(commentBookNib, forCellReuseIdentifier: "WBCommentsBookTableViewCell")
        
    }
}
