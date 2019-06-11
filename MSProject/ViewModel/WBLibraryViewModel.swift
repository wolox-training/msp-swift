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
        WBNetworkManager.manager.fetchBooks(onSuccess: { (books) in
            self.libraryItems = books.sorted(by: { $0.id < $1.id })
            self.cellViewModels = [] //clear array
            for book in self.libraryItems {
                self.cellViewModels.append(WBBookCellViewModel(bookImageURL: book.image, bookTitle: book.title, bookAuthor: book.author))
            }

        }) { (error) in
            print(error)
        }
        
    }
    
    func selectBook(at indexPath: IndexPath) {
        let book = cellViewModels[indexPath.row]
        print("\(book.bookTitle) \(book.bookAuthor)")
    }
}
