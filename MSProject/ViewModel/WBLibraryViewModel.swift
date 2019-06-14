//
//  WBLibraryViewModel.swift
//  MSProject
//
//  Created by Matias Spinelli on 11/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

class WBLibraryViewModel {
    
    var libraryItems: [WBBook] = [] {
        didSet {
            self.reloadViewClosure?()
        }
    }

    var numberOfCells: Int {
        return libraryItems.count
    }
    
    var heightOfCells: CGFloat {
        return 90.0+10.0 //le agrego 10 porque es lo que le quita el contentview
    }
    
    var reloadViewClosure: (() -> Void)?

    func getCellViewModel(at indexPath: IndexPath) -> WBBook {
        return libraryItems[indexPath.row]
    }
    
    func loadBooks() {
        WBNetworkManager.manager.fetchBooks(onSuccess: { (books) in
            self.libraryItems = books.sorted(by: { $0.id < $1.id })
        }) { (error) in
            print(error)
        }
    }
    
    func selectBook(at indexPath: IndexPath) {
        let book = libraryItems[indexPath.row]
        print("\(book.title) \(book.author)")
    }
}
