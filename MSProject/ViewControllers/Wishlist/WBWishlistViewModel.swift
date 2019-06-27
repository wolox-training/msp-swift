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
    
    let repository: WBBooksRepository
    
    init(booksRepository: WBBooksRepository) {
        repository = booksRepository
    }
    
    // MARK: - TableView
    var numberOfCells: Int {
        return WBBooksManager.sharedIntance.wishedBooks.value.count
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> WBBookViewModel {
        return WBBooksManager.sharedIntance.wishedBooks.value[indexPath.row]
    }
}
