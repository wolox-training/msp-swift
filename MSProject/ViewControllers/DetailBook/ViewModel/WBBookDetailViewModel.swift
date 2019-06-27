//
//  WBBookDetailViewModel.swift
//  MSProject
//
//  Created by Matias Spinelli on 13/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Networking

class WBBookDetailViewModel {

    private var commentsViewModels: MutableProperty<[WBComment]> = MutableProperty([])
    private var suggestionsBookViewModels: MutableProperty<[WBBookViewModel]> = MutableProperty([])

    var bookAvailable = MutableProperty(false)
    
    let repository: WBBooksRepository
    
    lazy var rentBookAction = Action(enabledIf: bookAvailable) { [unowned self] book in
        return self.rentBook(book: book)
    }
    
    init(booksRepository: WBBooksRepository) {
        repository = booksRepository
    }
    
    // MARK: - TableView
    var numberOfSections: Int {
        return 1 + (suggestionsBookViewModels.value.isEmpty ? 0 : 1)
    }
    
    func numberOfCells(for section: Int) -> Int {
        if section == 0 {
            return suggestionsBookViewModels.value.isEmpty ? 0 : 1
        } else {
            return commentsViewModels.value.count
        }
    }

    func getSuggestionsBookViewModel() -> [WBBookViewModel] {
        return suggestionsBookViewModels.value
    }
    
    func getCommentViewModel(at indexPath: IndexPath) -> WBComment {
        return commentsViewModels.value[indexPath.row]
    }

    // MARK: - Repository
    func rentBook(book: WBBook) -> SignalProducer<Void, RepositoryError> {
        WBBooksManager.sharedIntance.needsReload.value = true
        return repository.rentBook(book: book)
    }
    
    func wishBook(book: WBBook) -> SignalProducer<Void, RepositoryError> {
        WBBooksManager.sharedIntance.needsReload.value = true
        return repository.wishBook(book: book)
    }
    
    func loadComments(book: WBBook) -> SignalProducer<[WBComment], RepositoryError> {
        return self.repository.getBookComments(book: book).on(failed: { [unowned self] _ in self.commentsViewModels.value = [] }, value: { [unowned self] value in self.commentsViewModels.value = value })
    }
    
    func loadSuggestions(book: WBBook) -> SignalProducer<[WBBook], RepositoryError> {
        return self.repository.getBookSuggestions(book: book).on(failed: { [unowned self] _ in self.suggestionsBookViewModels.value = [] }, value: { [unowned self] value in
            self.suggestionsBookViewModels = MutableProperty(value.map { WBBookViewModel(book: $0) })
        })
    }
}
