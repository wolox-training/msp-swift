//
//  WBLibraryViewModel.swift
//  MSProject
//
//  Created by Matias Spinelli on 11/06/2019.
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

class WBLibraryViewModel {
    
    private var libraryItems: [WBBook] = []

    private var bookViewModels: [WBBookViewModel] = [] {
        didSet {
            reloadViewClosure?()
        }
    }
    
    var numberOfCells: Int {
        return bookViewModels.count
    }
    
    var reloadViewClosure: (() -> Void)?
    var showAlertClosure: ((Error) -> Void)?

    func getCellViewModel(at indexPath: IndexPath) -> WBBookViewModel {
        return bookViewModels[indexPath.row]
    }
    
    func loadBooks() {
        let successBooks: ([WBBook]) -> Void = { (books) in
            self.libraryItems = books
            self.sortBooks()
        }
        
        let failureBooks: (Error) -> Void = { (error) in
            self.showAlertClosure?(error)
        }
        
        WBNetworkManager.manager.fetchBooks(onSuccess: successBooks, onError: failureBooks)
    }
    
    func selectBook(at indexPath: IndexPath) -> WBBookViewModel {
        let book = bookViewModels[indexPath.row]
        print("\(book.bookTitle) - \(book.bookAuthor)")
        return book
    }
    
    func sortBooks() {
        sortBooks(books: &libraryItems, by: .id)
        bookViewModels = libraryItems.map { WBBookViewModel(book: $0) }
    }
    
    func sortBooks(books: inout [WBBook], by sortMethod: SortMethod) {
        switch sortMethod {
        case .id:
            books = books.sorted(by: { $0.id < $1.id })
        case .title:
            books = books.sorted(by: { $0.title < $1.title })
        case .author:
            books = books.sorted(by: { $0.author < $1.author })
        case .genre:
            books = books.sorted(by: { $0.genre < $1.genre })
        case .year:
            books = books.sorted(by: { $0.year < $1.year })
        }
    }
}
