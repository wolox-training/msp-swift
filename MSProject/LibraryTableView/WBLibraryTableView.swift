//
//  WBLibraryTableView.swift
//  MSProject
//
//  Created by Matias Spinelli on 10/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

class WBLibraryTableView: UIView, NibLoadable {

    @IBOutlet weak var libraryTableView: UITableView!
    
    var libraryItems: [WBBook] = []

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    // MARK: - Private
    func configureTableView() {
        libraryTableView.delegate = self
        libraryTableView.dataSource = self
        
        libraryTableView.backgroundColor = UIColor.woloxBackgroundLightColor()
        libraryTableView.separatorStyle = .none

        let nib = UINib.init(nibName: "WBBookTableViewCell", bundle: nil)
        libraryTableView.register(nib, forCellReuseIdentifier: "WBBookTableViewCell")
    }
}

// MARK: - UITableViewDataSource
extension WBLibraryTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0+10.0 //le agrego 10 porque es lo que le quita el contentview
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libraryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: WBBookTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WBBookTableViewCell", for: indexPath) as! WBBookTableViewCell // swiftlint:disable:this force_cast
        
        let book: WBBook = libraryItems[indexPath.row]
        
        cell.bookImage.image = UIImage(named: book.bookImageURL ?? "placeholder_image")
        cell.bookTitle.text = book.bookTitle
        cell.bookAuthor.text = book.bookAuthor
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension WBLibraryTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book: WBBook = libraryItems[indexPath.row]
        print("\(book.bookTitle ?? "") \(book.bookAuthor ?? "")")
        libraryTableView.deselectRow(at: indexPath, animated: true)
    }
    
}
