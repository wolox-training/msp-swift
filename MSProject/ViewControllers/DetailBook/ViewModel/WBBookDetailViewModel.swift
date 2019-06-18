//
//  WBBookDetailViewModel.swift
//  MSProject
//
//  Created by Matias Spinelli on 13/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

class WBBookDetailViewModel {

    var commentsViewModels: [WBComment] = [WBComment]()
    
    public let repository: WBNetworkManager
    
    init(booksRepository: WBNetworkManager) {
        repository = booksRepository
    }
    
    var numberOfCells: Int {
        return commentsViewModels.count
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> WBComment {
        return commentsViewModels[indexPath.row]
    }
}
