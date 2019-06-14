//
//  WBBook.swift
//  MSProject
//
//  Created by Matias Spinelli on 07/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

struct WBBook: Codable {
    
    let id: Int
    let title: String
    let author: String
    let genre: String
    let year: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case author
        case genre
        case year
        case image
    }
}
