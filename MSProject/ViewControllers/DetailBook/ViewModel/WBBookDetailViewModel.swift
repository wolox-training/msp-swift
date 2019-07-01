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

    var bookAvailable = MutableProperty(false)
    
    let repository: WBBooksRepository
    
    lazy var rentBookAction = Action(enabledIf: bookAvailable) { [unowned self] book in
        return self.rentBook(book: book)
    }
    
    init(booksRepository: WBBooksRepository) {
        repository = booksRepository
    }
    
    // MARK: - TableView
    var numberOfCells: Int {
        return commentsViewModels.value.count
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> WBComment {
        return commentsViewModels.value[indexPath.row]
    }

    // MARK: - Repository
    func rentBook(book: WBBook) -> SignalProducer<Void, RepositoryError> {
        return repository.rentBook(book: book)
    }
    
    func loadComments(book: WBBook) -> SignalProducer<[WBComment], RepositoryError> {
        return self.repository.getBookComments(book: book).on(failed: { [unowned self] _ in self.commentsViewModels.value = [] }, value: { [unowned self] value in self.commentsViewModels.value = value })
    }
}
