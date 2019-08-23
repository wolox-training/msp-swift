//
//  WBSearchView.swift
//  MSProject
//
//  Created by Matias Spinelli on 26/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

class WBSearchView: UIView, NibLoadable {

    @IBOutlet weak var searchTitle: UILabel!
    @IBOutlet weak var searchDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        searchTitle.text = "SEARCH_TITLE".localized()
        searchDescription.text = "SEARCH_DESCRIPTION".localized()
    }
    
}
