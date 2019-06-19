//
//  WBLibraryViewModel.swift
//  MSProject
//
//  Created by Matias Spinelli on 11/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class WBLibraryViewModel {
    
    var libraryItems: [WBBook] = [] {
        didSet {
            sortBooks()
        }
    }
//    private let libraryItems = MutableProperty<[WBBook]>([])
    private var bookViewModels: [WBBookViewModel] = []
    
    let repository: WBNetworkManager
    
    init(booksRepository: WBNetworkManager) {
        repository = booksRepository
    }
    
    var numberOfCells: Int {
        return bookViewModels.count
    }

    func getCellViewModel(at indexPath: IndexPath) -> WBBookViewModel {
        return bookViewModels[indexPath.row]
    }
    
    func selectBook(at indexPath: IndexPath) -> WBBookViewModel {
        return bookViewModels[indexPath.row]
    }
    
    // MARK: - Private
    func sortBooks() {
        let sortedBooks = WBBookDAO.sharedInstance.sortBooks(books: self.libraryItems, by: .id)
        self.bookViewModels = [] //clear array
        for book in sortedBooks {
            self.bookViewModels.append(WBBookViewModel(book: book))
        }
    }
}
