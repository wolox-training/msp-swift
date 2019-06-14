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

    private var bookViewModels: [WBBookViewModel] = [WBBookViewModel]() {
        didSet {
            self.reloadViewClosure?()
        }
    }
    
    var numberOfCells: Int {
        return bookViewModels.count
    }
    
    var heightOfCells: CGFloat {
        return 90.0+10.0 //le agrego 10 porque es lo que le quita el contentview
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
        self.libraryItems = WBBookDAO.sharedInstance.sortBooks(books: self.libraryItems, by: .id)
        self.bookViewModels = [] //clear array
        for book in self.libraryItems {
            self.bookViewModels.append(WBBookViewModel(book: book))
        }
    }
}
