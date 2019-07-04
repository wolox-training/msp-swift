//
//  WBCommentViewController.swift
//  MSProject
//
//  Created by Matias Spinelli on 27/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore
import ReactiveCocoa
import ReactiveSwift
import MBProgressHUD

class WBCommentViewController: UIViewController {

    private let _view: WBCommentView = WBCommentView.loadFromNib()!
    private let _detailHeaderView: WBDetailBookHeaderView = WBDetailBookHeaderView.loadFrom(nibName: "WBBookHeaderView")!

    lazy var viewModel: WBCommentViewModel = {
        return WBCommentViewModel(booksRepository: WBBooksRepository(configuration: networkingConfiguration, defaultHeaders: WBBooksRepository.commonHeaders()))
    }()
    
    var bookViewModel: WBBookViewModel!
    
    convenience init(with bookViewModel: WBBookViewModel) {
        self.init()
        self.bookViewModel = bookViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "COMMENT_NAV_BAR".localized()
        
        _view.submitButton?.reactive.controlEvents(.touchUpInside)
            .observeValues { _ in
                MBProgressHUD.showAdded(to: self._view, animated: true)
                
                self.viewModel.addBookComment(book: self.bookViewModel.book, comment: self._view.commentTextView.text).take(during: self.reactive.lifetime).startWithResult { [unowned self] result in
                    switch result {
                    case .success:
                        WBBooksManager.sharedIntance.needsReload.value = true
                        self.navigationController?.popToRootViewController(animated: true)
                    case .failure(let error):
                        self.showAlert(message: error.localizedDescription)
                    }
                    MBProgressHUD.hide(for: self._view, animated: true)
                }
        }
    }
    
    override func loadView() {
        _detailHeaderView.setup(with: bookViewModel)
        _view.detailHeaderView.addSubview(_detailHeaderView)
        view = _view
    }

}
