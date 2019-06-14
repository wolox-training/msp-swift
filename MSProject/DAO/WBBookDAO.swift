//
//  WBBookDAO.swift
//  MSProject
//
//  Created by Matias Spinelli on 07/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

enum SortMethod {
    case id
    case title
    case author
    case genre
    case year
}

class WBBookDAO: NSObject {
    
    public static let sharedInstance = WBBookDAO()
    
    override init() {}

    let imageCache = NSCache<NSString, UIImage>()
    
    func sortBooks(books: [WBBook], by sortMethod: SortMethod) -> [WBBook] {
        switch sortMethod {
        case .id:
            return books.sorted(by: { $0.id < $1.id })
        case .title:
            return books.sorted(by: { $0.title < $1.title })
        case .author:
            return books.sorted(by: { $0.author < $1.author })
        case .genre:
            return books.sorted(by: { $0.genre < $1.genre })
        case .year:
            return books.sorted(by: { $0.year < $1.year })
        }
    }
    
}
