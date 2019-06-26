//
//  WBWishlistViewModel.swift
//  MSProject
//
//  Created by Matias Spinelli on 26/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

import Networking

class WBWishlistViewModel {
    
    private var bookViewModels: MutableProperty<[WBBookViewModel]> = MutableProperty([])
    
    let repository: WBBooksRepository
    
    init(booksRepository: WBBooksRepository) {
        repository = booksRepository
    }
    
    // MARK: - TableView
    var numberOfCells: Int {
        return bookViewModels.value.count
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> WBBookViewModel {
        return bookViewModels.value[indexPath.row]
    }
    
    // MARK: - Repository
    func loadWishes() -> SignalProducer<[WBWish], RepositoryError> {
        return self.repository.getWishes().on(failed: { [unowned self] _ in self.bookViewModels.value = [] }, value: { [unowned self] value in
            self.bookViewModels = MutableProperty(value.map { WBBookViewModel(book: $0.book) })
            self.bookViewModels.value.forEach { $0.wished = true }
        })
    }
}
