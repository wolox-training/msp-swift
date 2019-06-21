//
//  WBButton.swift
//  BaseProject
//
//  Created by Matias Spinelli on 07/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

enum WBButtonStyle: CaseIterable {
    case bordered
    case filled
    case disabled
}

@IBDesignable
class WBButton: UIButton {

    // MARK: Inspectables
    @IBInspectable var borderLineWidth: CGFloat = 1.5 {
        didSet {
            layer.borderWidth = borderLineWidth
        }
    }
    
    @IBInspectable var borderLineColor: UIColor = .white {
       didSet {
            layer.borderColor = borderLineColor.cgColor
        }
    }

    @IBInspectable var borderLineRadius: CGFloat = 5 {
        didSet {
            layer.cornerRadius = borderLineRadius
        }
    }

    var buttonStyle: WBButtonStyle? {
        didSet {
            switch buttonStyle {
            case .bordered?:
                break
            case .filled?:
                blueGradientBackground()
            case .disabled?:
                grayGradientBackground()
            case .none:
                break
            }
        }
    }
    
    // MARK: - Private
    private func blueGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        gradient.colors = [
            UIColor(red: 0.0, green: 0.68, blue: 0.93, alpha: 1).cgColor,
            UIColor(red: 0.22, green: 0.8, blue: 0.8, alpha: 1).cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.cornerRadius = borderLineRadius
        borderLineWidth = 0.0
        layer.addSublayer(gradient)
        setTitleColor(.white, for: UIControl.State.normal)
    }
    
    private func grayGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        gradient.colors = [
            UIColor(red: 0.79, green: 0.79, blue: 0.79, alpha: 1).cgColor,
            UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1).cgColor,
            UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1).cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.cornerRadius = borderLineRadius
        borderLineWidth = 0.0
        layer.addSublayer(gradient)
        setTitleColor(.white, for: UIControl.State.normal)
    }
}
