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
    var showAlertClosure: ((Error) -> Void)?
    
    func getCellViewModel(at indexPath: IndexPath) -> WBComment {
        return commentsViewModels[indexPath.row]
    }
    
    func loadComments(for bookView: WBBookViewModel) {
        WBBookDAO.sharedInstance.getBookComments(delegate: self, book: bookView.book)
    }
    
}

// MARK: - WBCommentProtocol
extension WBBookDetailViewModel: WBCommentProtocol {
    func commentSucess(comments: [WBComment]) {
        commentsViewModels = comments
    }
    
    func commentFailue(error: Error) {
        self.showAlertClosure?(error)
    }
    
}
