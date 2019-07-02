//
//  WBCommentsBookTableViewCell.swift
//  MSProject
//
//  Created by Matias Spinelli on 13/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

class WBCommentsBookTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView! {
        didSet {
            userImage.layer.cornerRadius = userImage.frame.size.width/2
        }
    }
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userComment: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = .white
        backgroundColor = .clear
        
        selectionStyle = .blue
    }
    
    func setup(with comment: WBComment) {
        userImage.loadImageUsingCache(withUrl: comment.user.imageURL, placeholderImage: UIImage(named: "user_male")!)
        userName.text = comment.user.username
        userComment.text = comment.content
    }
    
}
