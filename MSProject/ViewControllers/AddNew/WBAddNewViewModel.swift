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
    
    init(booksRepository: WBBooksRepository) {
        repository = booksRepository
    }
    
    // MARK: - Repository
    func addBookComment(book: WBBook, comment: String) -> SignalProducer<Void, RepositoryError> {
        WBBooksManager.sharedIntance.needsReload.value = true
        return repository.addBookComment(book: book, comment: comment)
    }
    
}
