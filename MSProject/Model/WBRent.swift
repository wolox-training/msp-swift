//
//  WBRent.swift
//  MSProject
//
//  Created by Matias Spinelli on 12/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

import Argo
import Curry
import Runes

struct WBRent: Codable {

    let id: Int
    let from: String
    let to: String
    let bookID: Int
    let userID: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case from
        case to
        case bookID
        case userID
    }
    
}

extension WBRent: Argo.Decodable {
    
    static func decode(_ json: JSON) -> Decoded<WBRent> {
        return curry(WBRent.init)
            <^> json <| "id"
            <*> json <| "from"
            <*> json <| "to"
            <*> json <| "bookID"
            <*> json <| "userID"
    }
}
