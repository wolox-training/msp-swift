//
//  WBLibraryViewModel.swift
//  MSProject
//
//  Created by Matias Spinelli on 11/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

class WBLibraryViewModel {
    
    var libraryItems: [WBBook] = []

    private var cellViewModels: [WBBookCellViewModel] = [WBBookCellViewModel]() {
        didSet {
            self.reloadViewClosure?()
        }
    }

    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var heightOfCells: CGFloat {
        return 90.0+10.0 //le agrego 10 porque es lo que le quita el contentview
    }
    
    var reloadViewClosure: (() -> Void)?

    func getCellViewModel(at indexPath: IndexPath) -> WBBookCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func loadBooks() {
        
        // animation
        // load books
        WBBookDAO.sharedInstance.getAllBooks(delegate: self)
    }
    
    func selectBook(at indexPath: IndexPath) -> WBBookCellViewModel {
        let book = cellViewModels[indexPath.row]
        print("\(book.bookTitle) - \(book.bookAuthor)")
        return book
    }
    
}

// MARK: - WBBooksProtocol
extension WBLibraryViewModel: WBBooksProtocol {
    func booksSucess(books: [WBBook]) {
        //stop animation
        
        self.libraryItems = WBBookDAO.sharedInstance.sortBooks(books: books)
        self.cellViewModels = [] //clear array
        for book in self.libraryItems {
            self.cellViewModels.append(WBBookCellViewModel(bookId: String(book.id), bookTitle: book.title, bookAuthor: book.author, bookGenre: book.genre, bookYear: book.year, bookImageURL: book.image))
        }
    }
    
    func booksFailue(error: Error) {
        // stop animation
        
        print(error)
        
        // show alert
        
    }
    
}
