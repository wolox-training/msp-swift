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
    private var filteredBookViewModels: [WBBookViewModel] = []

    var isFiltering = false
    
    let state: MutableProperty<ViewState> = MutableProperty(ViewState.loading)

    let repository: WBBooksRepository
    
    init(booksRepository: WBBooksRepository) {
        repository = booksRepository
    }
    
    var numberOfCells: Int {
        if isFiltering {
            return filteredBookViewModels.count
        } else {
            return bookViewModels.count
        }
    }

    func getCellViewModel(at indexPath: IndexPath) -> WBBookViewModel {
        if isFiltering {
            return filteredBookViewModels[indexPath.row]
        } else {
            return bookViewModels[indexPath.row]
        }
    }
    
    func selectBook(at indexPath: IndexPath) -> WBBookViewModel {
        if isFiltering {
            return filteredBookViewModels[indexPath.row]
        } else {
            return bookViewModels[indexPath.row]
        }
    }
    
    func sortBooks() {
        sortBooks(books: &libraryItems, by: .id)
        bookViewModels = libraryItems.map { WBBookViewModel(book: $0) }
    }
    
    func filterBooks(with searchText: String) {
        filteredBookViewModels = bookViewModels.filter({ (book: WBBookViewModel) -> Bool in
            return book.bookTitle.lowercased().contains(searchText.lowercased())
        })
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
