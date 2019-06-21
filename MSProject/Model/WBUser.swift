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

struct WBUser {
    
    let id: Int
    let username: String
    let imageURL: String
}

extension WBUser: Argo.Decodable {
    
    static func decode(_ json: JSON) -> Decoded<WBUser> {
        return curry(WBUser.init)
            <^> json <| "id"
            <*> json <| "username"
            <*> json <| "image"
    }
}
