//
//  WBBookDAO.swift
//  MSProject
//
//  Created by Matias Spinelli on 07/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

class WBBookDAO: NSObject {
    
    public static let sharedInstance = WBBookDAO()
    
    override init() {}

    func getAllBooks() -> [WBBook] {
        var array: [WBBook] = []
        
        let bookOne = WBBook()
        bookOne.bookImage = UIImage(named: "img_book1")
        bookOne.bookTitle = "TITLE"
        bookOne.bookAuthor = "AUTHOR"
        
        array.append(bookOne)
        
        return array
    }

}
