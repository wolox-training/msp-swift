//
//  WBComment.swift
//  MSProject
//
//  Created by Matias Spinelli on 13/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

struct WBComment: Codable {

    let id: Int
    let content: String
    let book: WBBook
    let user: WBUser
    
    enum CodingKeys: String, CodingKey {
        case id
        case content
        case book
        case user
    }
}
