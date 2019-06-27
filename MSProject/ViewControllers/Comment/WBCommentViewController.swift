//
//  WBCommentViewController.swift
//  MSProject
//
//  Created by Matias Spinelli on 27/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

class WBCommentViewController: UIViewController {

    private let _view: WBCommentView = WBCommentView.loadFromNib()!
    private let _detailHeaderView: WBDetailBookHeaderView = WBDetailBookHeaderView.loadFrom(nibName: "WBBookHeaderView")!

    var bookViewModel: WBBookViewModel!
    
    convenience init(with bookViewModel: WBBookViewModel) {
        self.init()
        self.bookViewModel = bookViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "COMMENT_NAV_BAR".localized()
    }
    
    override func loadView() {
        _detailHeaderView.configureUI()
        _detailHeaderView.setup(with: bookViewModel)
        _view.detailHeaderView.addSubview(_detailHeaderView)
        _view.configureDetailTableView()
        view = _view
    }

}
