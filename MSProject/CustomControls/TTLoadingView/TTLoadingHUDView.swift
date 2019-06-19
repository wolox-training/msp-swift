//
//  TTLoadingHUDView.swift
//  TTLoadingHUDView
//
//  Created by Matías Spinelli on 8/7/17.
//  Copyright © 2017 Matías Spinelli. All rights reserved.
//

import UIKit

final class TTLoadingHUDView: UIView {
        
    var successMessage: String = ""
    
    static var sharedView: TTLoadingHUDView = {
        return UINib(nibName: "TTLoadingHUDView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TTLoadingHUDView // swiftlint:disable:this force_cast
    }()

    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: - Setter
    
    class func set(successMessage message: String) {
        sharedView.successMessage = message
    }
    
    // MARK: - Showing Methods
    func showLoading(withMessage message: String) {
        messageLabel.text = message
        showLoading()
    }

    func showLoading() {
        let keyWindow: UIWindow = UIApplication.shared.keyWindow!
        let view: UIView = (keyWindow.rootViewController?.view)!
        self.showLoading(inView: view)
    }
    
    func showLoading(inView view: UIView) {
        self.frame = view.frame
        if !view.subviews.contains(self) {
            view.addSubview(self)
        }
        loadingIndicator.startAnimating()
    }
    
    // MARK: - Hide Methods
    func hideViewWithSuccess() {
        loadingIndicator.stopAnimating()
        statusImage.image = UIImage(named: "TTHudSuccess")
        messageLabel.text = self.successMessage
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.hideView()
        }
    }
    
    func hideViewWithFailure(_ errorMessage: Error) {
        loadingIndicator.stopAnimating()
        statusImage.image = UIImage(named: "TTHudFailure")
        messageLabel.text = errorMessage.localizedDescription
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
            self.hideView()
        }
    }
    
    private func hideView() {
        loadingIndicator.stopAnimating()
        statusImage.image = nil
        messageLabel.text = ""
        self.removeFromSuperview()
    }
}
