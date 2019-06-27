//
//  WBRentalsViewModel.swift
//  MSProject
//
//  Created by Matias Spinelli on 26/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

import Networking

class WBRentalsViewModel {

    private var suggestionsBookViewModels: MutableProperty<[WBBookViewModel]> = MutableProperty([])

    let repository: WBBooksRepository
    
    init(booksRepository: WBBooksRepository) {
        repository = booksRepository
    }
    
    // MARK: - TableView
    var numberOfSections: Int {
        return 1 + (suggestionsBookViewModels.value.isEmpty ? 0 : 1)
    }
    
    func numberOfCells(for section: Int) -> Int {
        if section == 1 {
            return suggestionsBookViewModels.value.isEmpty ? 0 : 1
        } else {
            return WBBooksManager.sharedIntance.rentedBooks.value.count
        }
    }
    
    func getSuggestionsBookViewModel() -> [WBBookViewModel] {
        return suggestionsBookViewModels.value
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> WBBookViewModel {
        return WBBooksManager.sharedIntance.rentedBooks.value[indexPath.row]
    }
    
    // MARK: - Repository
    func loadSuggestions() -> SignalProducer<[WBBook], RepositoryError> {
        return self.repository.getSuggestions().on(failed: { [unowned self] _ in self.suggestionsBookViewModels.value = [] }, value: { [unowned self] value in
            self.suggestionsBookViewModels = MutableProperty(value.map { WBBookViewModel(book: $0) })
        })
    }
}
