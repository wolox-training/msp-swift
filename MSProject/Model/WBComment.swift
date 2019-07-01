//
//  WBComment.swift
//  MSProject
//
//  Created by Matias Spinelli on 13/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

import Argo
import Curry
import Runes

struct WBComment {

    let id: Int
    let content: String
    let book: WBBook
    let user: WBUser
}

extension WBComment: Argo.Decodable {
    
    static func decode(_ json: JSON) -> Decoded<WBComment> {
        return curry(WBComment.init)
            <^> json <| "id"
            <*> json <| "content"
            <*> json <| "book"
            <*> json <| "user"
    }
}
