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

    var commentsViewModels: [WBComment] = []
    
    var bookAvailable = MutableProperty(false)
    
    let repository: WBBooksRepository
    
    lazy var rentBookAction = Action(enabledIf: bookAvailable) { [unowned self] book in
        return self.rentBook(book: book)
    }
    
    init(booksRepository: WBBooksRepository) {
        repository = booksRepository
    }
    
    var numberOfCells: Int {
        return commentsViewModels.count
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> WBComment {
        return commentsViewModels[indexPath.row]
    }

    func rentBook(book: WBBook) -> SignalProducer<Void, RepositoryError> {
        return repository.rentBook(book: book)
    }
}
