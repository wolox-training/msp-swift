//
//  WBUser.swift
//  MSProject
//
//  Created by Matias Spinelli on 13/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

import Argo
import Curry
import Runes

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

extension WBUser: Argo.Decodable {
    
    static func decode(_ json: JSON) -> Decoded<WBUser> {
        return curry(WBUser.init)
            <^> json <| "id"
            <*> json <| "username"
            <*> json <| "image"
    }
}
