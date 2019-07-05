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

enum BookDetailSections: Int, CaseIterable {
    case bookDetail
    case suggestions
    case comments
}

class WBBookDetailViewModel {

    private var commentsViewModels: MutableProperty<[WBComment]> = MutableProperty([])
    private var suggestionsBookViewModels: MutableProperty<[WBBookViewModel]> = MutableProperty([])
    
    let repository: WBBooksRepository
    
    lazy var rentBookAction = Action<(WBBookViewModel), Void, RepositoryError> { [unowned self] bookViewModel in
        
        if bookViewModel.rented || bookViewModel.bookStatus != .available {
            return SignalProducer(error: RepositoryError.invalidURL)
        }
        return self.rentBook(bookViewModel: bookViewModel)
    }

    lazy var wishBookAction = Action<(WBBookViewModel), Void, RepositoryError> { [unowned self] bookViewModel in
        
        if bookViewModel.rented || bookViewModel.wished {
            return SignalProducer(error: RepositoryError.invalidURL)
        }
        return self.wishBook(bookViewModel: bookViewModel)
    }
    
    init(booksRepository: WBBooksRepository) {
        repository = booksRepository
    }
    
    // MARK: - TableView
    var numberOfSections: Int {
        return BookDetailSections.allCases.count
    }
    
    func numberOfCells(for section: BookDetailSections) -> Int {
        switch section {
        case .bookDetail:
            return 1
        case .suggestions:
            return suggestionsBookViewModels.value.isEmpty ? 0 : 1
        case .comments:
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
    func rentBook(bookViewModel: WBBookViewModel) -> SignalProducer<Void, RepositoryError> {
        WBBooksManager.sharedIntance.needsReload.value = true
        return repository.rentBook(book: bookViewModel.book)
    }
    
    func wishBook(bookViewModel: WBBookViewModel) -> SignalProducer<Void, RepositoryError> {
        WBBooksManager.sharedIntance.needsReload.value = true
        return repository.wishBook(book: bookViewModel.book)
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
