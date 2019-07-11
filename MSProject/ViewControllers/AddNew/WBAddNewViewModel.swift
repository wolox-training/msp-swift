//
//  WBAddNewViewModel.swift
//  MSProject
//
//  Created by Matias Spinelli on 28/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Networking

class WBAddNewViewModel: NSObject {

    let repository: WBBooksRepository
    
    lazy var addBookAction = Action<(WBBook), WBBook, RepositoryError> { [unowned self] book in

        if book.title == "" || book.author == "" || book.genre == "" || book.year == "" {
            return SignalProducer(error: RepositoryError.invalidURL)
        }
        
        return self.addBook(book: book)
    }
    
    init(booksRepository: WBBooksRepository) {
        repository = booksRepository
    }
    
    // MARK: - Repository
    func addBook(book: WBBook) -> SignalProducer<WBBook, RepositoryError> {
        WBBooksManager.sharedIntance.needsReload.value = true
        return repository.addBook(book: book)
    }
    
}
