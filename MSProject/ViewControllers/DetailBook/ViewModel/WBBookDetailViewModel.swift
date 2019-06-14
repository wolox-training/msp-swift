//
//  WBBookDetailViewModel.swift
//  MSProject
//
//  Created by Matias Spinelli on 13/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

class WBBookDetailViewModel {

    private var commentsViewModels: [WBComment] = [WBComment]() {
        didSet {
            self.reloadViewClosure?()
        }
    }
    
    var numberOfCells: Int {
        return commentsViewModels.count
    }
    
    var heightOfCells: CGFloat {
        return 90.0+10.0 //le agrego 10 porque es lo que le quita el contentview
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
            TTLoadingHUDView.sharedView.hideViewWithFailure(error)
            self.showErrorAlertClosure?(error)
        }
        
        WBNetworkManager.manager.rentBook(book: book.book, onSuccess: successRent, onError: failureRent)
    }
}
