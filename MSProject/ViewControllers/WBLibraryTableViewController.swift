//
//  WBLibraryTableViewController.swift
//  MSProject
//
//  Created by Matias Spinelli on 07/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

class WBLibraryTableViewController: UIViewController {

    @IBOutlet weak var libraryTableView: UITableView!

    var libraryItems: [WBBook] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureTableView()
        self.loadBooks()
    }
    
    // MARK: - Private
    private func configureTableView() {
        self.libraryTableView.delegate = self
        self.libraryTableView.dataSource = self
        
        self.libraryTableView.backgroundColor = UIColor.woloxBackgroundColor()

        let nib = UINib.init(nibName: "WBBookTableViewCell", bundle: nil)
        self.libraryTableView.register(nib, forCellReuseIdentifier: "WBBookTableViewCell")
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Services
    func loadBooks() {
        
        self.libraryItems = WBBookDAO.sharedInstance.getAllBooks()
        self.libraryTableView.reloadData()
        
    }
    
}

// MARK: - UITableViewDataSource
extension WBLibraryTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libraryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: WBBookTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WBBookTableViewCell", for: indexPath) as! WBBookTableViewCell // swiftlint:disable:this force_cast
        
        let book: WBBook = libraryItems[indexPath.row]
        
            cell.bookImage.image = book.bookImage
            cell.bookTitle.text = book.bookTitle
            cell.bookAuthor.text = book.bookAuthor

        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension WBLibraryTableViewController: UITableViewDelegate {
    
}
