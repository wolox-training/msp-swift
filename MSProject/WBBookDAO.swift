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
        
        let bookOne = WBBook(bookImageURL: "img_book1", bookTitle: "TITLE 1", bookAuthor: "AUTHOR 1")
        array.append(bookOne)

        let bookTwo = WBBook(bookImageURL: "img_book2", bookTitle: "TITLE 2", bookAuthor: "AUTHOR 2")
        array.append(bookTwo)
        
        let bookThree = WBBook(bookImageURL: "img_book3", bookTitle: "TITLE 3", bookAuthor: "AUTHOR 3")
        array.append(bookThree)
        
        let bookFour = WBBook(bookImageURL: "img_book4", bookTitle: "TITLE 4", bookAuthor: "AUTHOR 4")
        array.append(bookFour)
        
        let bookFive = WBBook(bookImageURL: "img_book5", bookTitle: "TITLE 5", bookAuthor: "AUTHOR 5")
        array.append(bookFive)
        
        let bookSix = WBBook(bookImageURL: "img_book6", bookTitle: "TITLE 6", bookAuthor: "AUTHOR 6")
        array.append(bookSix)
        
        return array
    }

}
