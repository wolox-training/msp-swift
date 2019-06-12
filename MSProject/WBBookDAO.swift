//
//  WBBookDAO.swift
//  MSProject
//
//  Created by Matias Spinelli on 07/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

protocol WBBooksProtocol {
    func booksSucess(books: [WBBook])
    func booksFailue(error: Error)
}

class WBBookDAO: NSObject {
    
    public static let sharedInstance = WBBookDAO()
    
    override init() {}

    let imageCache = NSCache<NSString, UIImage>()
    
    var libraryBooks: [WBBook] = []

    func getAllBooks(delegate: WBBooksProtocol) {
        
        if !libraryBooks.isEmpty {
            delegate.booksSucess(books: libraryBooks)
        }
        
        let sucessBooks: ([WBBook]) -> Void = { books in
            self.libraryBooks = books
            delegate.booksSucess(books: self.libraryBooks)
        }
        
        let failureBooks: (Error) -> Void = { error in
            delegate.booksFailue(error: error)
        }
        
        WBNetworkManager.manager.fetchBooks(onSuccess: sucessBooks, onError: failureBooks)
    }
    
    func sortBooks(books: [WBBook]) -> [WBBook] {
        return books.sorted(by: { $0.id < $1.id })
    }
    
}
