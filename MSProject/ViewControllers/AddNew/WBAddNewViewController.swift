//
//  WBAddNewViewController.swift
//  MSProject
//
//  Created by Matias Spinelli on 10/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore
import ReactiveCocoa
import ReactiveSwift
import MBProgressHUD

class WBAddNewViewController: UIViewController {

    private let _view: WBAddNewView = WBAddNewView.loadFromNib()!

    lazy var viewModel: WBAddNewViewModel = {
        return WBAddNewViewModel(booksRepository: WBBooksRepository(configuration: networkingConfiguration, defaultHeaders: WBBooksRepository.commonHeaders()))
    }()
    
    var bookTitle = MutableProperty("")
    var bookAuthor = MutableProperty("")
    var bookGenre = MutableProperty("")
    var bookYear = MutableProperty("")
    var bookImageURL = MutableProperty("")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "ADDNEW_NAV_BAR".localized()
        
        _view.addImageButton?.reactive.controlEvents(.touchUpInside)
            .observeValues { _ in
                let alertController = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
      
                let chooseAction = UIAlertAction(title: "Gallery", style: .default) { _ in
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.delegate = self
                    imagePickerController.sourceType = .photoLibrary
                    self.present(imagePickerController, animated: true, completion: .none)
                }
                alertController.addAction(chooseAction)
                
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let takeAction = UIAlertAction(title: "Camera", style: .default) { _ in
                        let imagePickerController = UIImagePickerController()
                        imagePickerController.delegate = self
                        imagePickerController.sourceType = .camera
                        self.present(imagePickerController, animated: true, completion: .none)
                    }
                    alertController.addAction(takeAction)
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: .none)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
        }
       
        _view.nameTextField.reactive.text <~ self.bookTitle
        _view.nameTextField.reactive.textValues.observeValues { (text) in
            self.bookTitle.value = text
        }

        _view.authorTextField.reactive.text <~ self.bookAuthor
        _view.authorTextField
            .reactive.textValues.observeValues { (text) in
            self.bookAuthor.value = text
        }
        
        _view.yearTextField.reactive.text <~ self.bookYear
        _view.yearTextField
            .reactive.textValues.observeValues { (text) in
            self.bookYear.value = text
        }
        
        _view.topicTextField.reactive.text <~ self.bookGenre
        _view.topicTextField
            .reactive.textValues.observeValues { (text) in
            self.bookGenre.value = text
        }
        
        _view.submitButton?.reactive.controlEvents(.touchUpInside)
            .observeValues { _ in
                MBProgressHUD.showAdded(to: self._view, animated: true)
                
                let book = WBBook(id: 0, title: self.bookTitle.value, author: self.bookAuthor.value, status: BookStatus.available.rawValue, genre: self.bookGenre.value, year: self.bookYear.value, imageURL: "")
                
                self.viewModel.addBook(book: book).startWithResult { [unowned self] result in
                    switch result {
                    case .success:
                        WBBooksManager.sharedIntance.needsReload.value = true

                        // RECARGAR LA VISTA VACIA (?
                        
                    case .failure(let error):
                        self.showAlert(message: error.localizedDescription)
                    }
                    MBProgressHUD.hide(for: self._view, animated: true)
                }
        }
    }
    
    override func loadView() {
        _view.configureDetailTableView()
        view = _view
    }
}

extension WBAddNewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        _view.addImageButton.setImage(image, for: UIControl.State.normal)
        
        picker.dismiss(animated: true, completion: nil)

    }

}
