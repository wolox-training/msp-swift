//
//  WBUser.swift
//  MSProject
//
//  Created by Matias Spinelli on 13/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

struct WBUser: Codable {
    
    let id: Int
    let username: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case imageURL = "image"
    }
}
