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

protocol WBRentProtocol {
    func rentSucess(rent: WBRent)
    func rentFailue(error: Error)
}
protocol WBCommentProtocol {
    func commentSucess(comments: [WBComment])
    func commentFailue(error: Error)
}

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
    
    var libraryBooks: [WBBook] = []

    func getAllBooks(delegate: WBBooksProtocol) {
        
        guard libraryBooks.isEmpty else {
            delegate.booksSucess(books: libraryBooks)
            return
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
    
    func rentBook(delegate: WBRentProtocol, book: WBBook) {

        let sucessRented: (WBRent) -> Void = { rent in
            delegate.rentSucess(rent: rent)
        }
        
        let failureRented: (Error) -> Void = { error in
            delegate.rentFailue(error: error)
        }
        
        WBNetworkManager.manager.rentBook(book: book, onSuccess: sucessRented, onError: failureRented)
    }
    
    func getBookComments(delegate: WBCommentProtocol, book: WBBook) {
        
        let sucessComments: ([WBComment]) -> Void = { comments in
            delegate.commentSucess(comments: comments)
        }
        
        let failureComments: (Error) -> Void = { error in
            delegate.commentFailue(error: error)
        }
        
        WBNetworkManager.manager.getBookComments(book: book, onSuccess: sucessComments, onError: failureComments)
    }
}
