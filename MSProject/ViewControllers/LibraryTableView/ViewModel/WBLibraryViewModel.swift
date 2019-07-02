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

    let state: MutableProperty<ViewState> = MutableProperty(.loading)

    let repository: WBBooksRepository
    
    init(booksRepository: WBBooksRepository) {
        repository = booksRepository
    }
    
    // MARK: - TableView
    var numberOfCells: Int {
        if isFiltering {
            return filteredBookViewModels.value.count
        } else {
            return WBBooksManager.sharedIntance.bookViewModels.value.count
        }
    }

    func getCellViewModel(at indexPath: IndexPath) -> WBBookViewModel {
        if isFiltering {
            return filteredBookViewModels.value[indexPath.row]
        } else {
            return WBBooksManager.sharedIntance.bookViewModels.value[indexPath.row]
        }
    }
    
    // MARK: - Public
    func filterBooks(with searchText: String) {
        filteredBookViewModels.value = WBBooksManager.sharedIntance.bookViewModels.value.filter({ (book: WBBookViewModel) -> Bool in
            return book.bookTitle.lowercased().contains(searchText.lowercased()) || book.bookAuthor.lowercased().contains(searchText.lowercased())
        })
    }
    
    func getBookById(id: String) -> WBBookViewModel? {
        return WBBooksManager.sharedIntance.bookViewModels.value.first { $0.bookId == id }
    }
    
    // MARK: - Repository
    func loadBooks() -> SignalProducer<[WBBook], RepositoryError> {
        return self.repository.getBooks().on(failed: { _ in WBBooksManager.sharedIntance.bookViewModels.value = [] }, value: { value in
            WBBooksManager.sharedIntance.bookViewModels = MutableProperty(value.map { WBBookViewModel(book: $0) })
            WBBooksManager.sharedIntance.sortBooks(by: .id)
            WBBooksManager.sharedIntance.indexSearchableItems()
        })
    }
    
    func loadRents() -> SignalProducer<[WBRent], RepositoryError> {
        return self.repository.getRents().on(failed: { _ in  }, value: { value in
            for rent in value {
                WBBooksManager.sharedIntance.bookViewModels.value.forEach {
                    if $0.book.id == rent.book!.id {
                        $0.rented = true
                        $0.rentedDateTo = rent.to
                        $0.rentedDateFrom = rent.from
                    }
                }
            }
        })
    }

    func loadWishes() -> SignalProducer<[WBWish], RepositoryError> {
        return self.repository.getWishes().on(failed: { _ in  }, value: { value in
            
            let whisedBooks = value.map { $0.book.id }
            WBBooksManager.sharedIntance.bookViewModels.value.forEach { $0.wished =  whisedBooks.contains($0.book.id) ? true : false }
        })
    }

}
