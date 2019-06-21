//
//  WBBookDetailViewModel.swift
//  MSProject
//
//  Created by Matias Spinelli on 13/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

class WBBookDetailViewModel {

    private var commentsViewModels: [WBComment] = [] {
        didSet {
            reloadViewClosure?()
        }
    }
    
    var numberOfCells: Int {
        return commentsViewModels.count
    }
    
    var reloadViewClosure: (() -> Void)?
    var showErrorAlertClosure: ((Error) -> Void)?
    var showAlertClosure: ((String) -> Void)?
    
    func getCellViewModel(at indexPath: IndexPath) -> WBComment {
        return commentsViewModels[indexPath.row]
    }
    
    func loadComments(for bookView: WBBookViewModel) {
        
        let successComments: ([WBComment]) -> Void = { (comments) in
            self.commentsViewModels = comments
        }
        
        let failureComments: (Error) -> Void = { (error) in
            self.showErrorAlertClosure?(error)
        }
        
        WBNetworkManager.manager.getBookComments(book: bookView.book, onSuccess: successComments, onError: failureComments)
    }
    
    func rentBook(book: WBBookViewModel) {
        
        let successRent: (WBRent) -> Void = { (rent) in
            self.showAlertClosure?("Se reservo el libro correctamente")
        }
        
        let failureRent: (Error) -> Void = { (error) in
            self.showErrorAlertClosure?(error)
        }
        
        WBNetworkManager.manager.rentBook(book: book.book, onSuccess: successRent, onError: failureRent)
    }
}
