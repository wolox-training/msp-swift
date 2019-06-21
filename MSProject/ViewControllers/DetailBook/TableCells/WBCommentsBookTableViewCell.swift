//
//  WBCommentsBookTableViewCell.swift
//  MSProject
//
//  Created by Matias Spinelli on 13/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

class WBCommentsBookTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userComment: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = .white
        backgroundColor = .clear
        
        selectionStyle = .blue
        
        userImage.layer.cornerRadius = userImage.frame.size.width/2
    }

    var commentViewModel: WBComment? {
        didSet {
            userImage.loadImageUsingCache(withUrl: commentViewModel?.user.imageURL ?? "", placeholderImage: .placeholderUserImage)
            userName.text = commentViewModel?.user.username
            userComment.text = commentViewModel?.content
        }
    }
}
