//
//  WBBookTableViewCell.swift
//  MSProject
//
//  Created by Matias Spinelli on 07/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

class WBBookTableViewCell: UITableViewCell {

    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var customBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customBackgroundView.layer.cornerRadius = 5
        customBackgroundView.backgroundColor = .white
        contentView.sendSubviewToBack(customBackgroundView)

        backgroundColor = .clear        
        
        selectionStyle = .blue
    }
}
