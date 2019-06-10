//
//  WBBook.swift
//  MSProject
//
//  Created by Matias Spinelli on 07/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

struct WBBook: Codable {
    
    var bookImageURL: String?
    var bookTitle: String?
    var bookAuthor: String?

    enum CodingKeys: String, CodingKey {
        case bookImageURL
        case bookTitle
        case bookAuthor
    }
}
