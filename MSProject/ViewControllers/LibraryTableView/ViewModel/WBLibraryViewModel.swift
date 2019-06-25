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

import Networking

enum SortMethod {
    case id
    case title
    case author
    case genre
    case year
}

class WBLibraryViewModel {
    
    private var filteredBookViewModels: MutableProperty<[WBBookViewModel]> = MutableProperty([])
    var isFiltering = false

    private var bookViewModels: MutableProperty<[WBBookViewModel]> = MutableProperty([])
    
    let state: MutableProperty<ViewState> = MutableProperty(ViewState.loading)

    let repository: WBBooksRepository
    
    init(booksRepository: WBBooksRepository) {
        repository = booksRepository
    }
    
    var numberOfCells: Int {
        if isFiltering {
            return filteredBookViewModels.value.count
        } else {
            return bookViewModels.value.count
        }
    }

    func getCellViewModel(at indexPath: IndexPath) -> WBBookViewModel {
        if isFiltering {
            return filteredBookViewModels.value[indexPath.row]
        } else {
            return bookViewModels.value[indexPath.row]
        }
    }
    
    func loadBooks() -> SignalProducer<[WBBook], RepositoryError> {
        return self.repository.getBooks().on(failed: { [unowned self] _ in self.bookViewModels = MutableProperty([]) }, value: { [unowned self] value in
            self.bookViewModels = MutableProperty(value.map { WBBookViewModel(book: $0) })
            self.sortBooks(by: .id)
        })
    }
    
    func sortBooks(by: SortMethod) {
        sortBooks(books: &bookViewModels.value, by: .id)
    }
    
    func filterBooks(with searchText: String) {
        filteredBookViewModels.value = bookViewModels.value.filter({ (book: WBBookViewModel) -> Bool in
            return book.bookTitle.lowercased().contains(searchText.lowercased()) || book.bookAuthor.lowercased().contains(searchText.lowercased())
        })
    }
    
    // MARK: - Private
    private func sortBooks(books: inout [WBBookViewModel], by sortMethod: SortMethod) {
        switch sortMethod {
        case .id:
            books = books.sorted(by: { $0.book.id < $1.book.id })
        case .title:
            books = books.sorted(by: { $0.book.title < $1.book.title })
        case .author:
            books = books.sorted(by: { $0.book.author < $1.book.author })
        case .genre:
            books = books.sorted(by: { $0.book.genre < $1.book.genre })
        case .year:
            books = books.sorted(by: { $0.book.year < $1.book.year })
        }
    }
}
