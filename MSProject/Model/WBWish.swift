//
//  WBWish.swift
//  MSProject
//
//  Created by Matias Spinelli on 13/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

import Argo
import Curry
import Runes

struct WBWish: Codable {
    
    let id: Int
    let book: WBBook
    let user: WBUser
    
    enum CodingKeys: String, CodingKey {
        case id
        case book
        case user
    }
}

extension WBWish: Argo.Decodable {
    
    static func decode(_ json: JSON) -> Decoded<WBWish> {
        return curry(WBWish.init)
            <^> json <| "id"
            <*> json <| "book"
            <*> json <| "user"
    }
}
