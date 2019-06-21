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

enum SortMethod {
    case id
    case title
    case author
    case genre
    case year
}

class WBLibraryViewModel {
    
    var libraryItems: [WBBook] = []
//    private let libraryItems = MutableProperty<[WBBook]>([])
    private var bookViewModels: [WBBookViewModel] = []
    
    let repository: WBBooksRepository
    
    init(booksRepository: WBBooksRepository) {
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
    
    func sortBooks() {
        sortBooks(books: &libraryItems, by: .id)
        bookViewModels = libraryItems.map { WBBookViewModel(book: $0) }
    }
    
    // MARK: - Private
    private func sortBooks(books: inout [WBBook], by sortMethod: SortMethod) {
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
