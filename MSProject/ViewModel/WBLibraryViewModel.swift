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

    private var cellViewModels: [WBBookViewModel] = [WBBookViewModel]() {
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
    var showAlertClosure: ((Error) -> Void)?

    func getCellViewModel(at indexPath: IndexPath) -> WBBookViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func loadBooks() {
        WBBookDAO.sharedInstance.getAllBooks(delegate: self)
    }
    
    func selectBook(at indexPath: IndexPath) -> WBBookViewModel {
        let book = cellViewModels[indexPath.row]
        print("\(book.bookTitle) - \(book.bookAuthor)")
        return book
    }
    
}

// MARK: - WBBooksProtocol
extension WBLibraryViewModel: WBBooksProtocol {
    func booksSucess(books: [WBBook]) {
        self.libraryItems = WBBookDAO.sharedInstance.sortBooks(books: books, by: .id)
        self.cellViewModels = [] //clear array
        for book in self.libraryItems {
            self.cellViewModels.append(WBBookViewModel(book: book))
        }
    }
    
    func booksFailue(error: Error) {
        self.showAlertClosure?(error)
    }
    
}
