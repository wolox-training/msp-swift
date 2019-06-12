//
//  Transition.swift
//  PushTransition
//
//  Created by Alejandro Zalazar on 02/05/2019.
//  Copyright © 2019 Ninja Conf. All rights reserved.
//

import UIKit

class Transition: NSObject, UIViewControllerAnimatedTransitioning {
	
	var isPresenting: Bool
	var originFrame: CGRect
    var transitionImage: UIImage
    
    init(isPresenting: Bool, originFrame: CGRect, transitionImage: UIImage) {
		self.isPresenting = isPresenting
		self.originFrame = originFrame
        self.transitionImage = transitionImage
	}
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(UINavigationControllerHideShowBarDuration)
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		
		let duration = transitionDuration(using: transitionContext)
		
		let container = transitionContext.containerView
		
		guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
		guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
		
		self.isPresenting ? container.addSubview(toView) : container.insertSubview(toView, belowSubview: fromView)
		
		let detailView = isPresenting ? toView : fromView
		
		guard let artwork = detailView.viewWithTag(99) as? UIImageView else { return }
		artwork.image = transitionImage
		artwork.alpha = 0
		
		let transitionImageView = UIImageView(frame: isPresenting ? originFrame : artwork.frame)
        transitionImageView.contentMode = .scaleAspectFit
        transitionImageView.image = transitionImage
        
		container.addSubview(transitionImageView)
		
		toView.frame = isPresenting ?  CGRect(x: fromView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height) : toView.frame
		toView.alpha = isPresenting ? 0 : 1
		toView.layoutIfNeeded()
		
		UIView.animate(withDuration: duration, animations: {
			transitionImageView.frame = self.isPresenting ? artwork.frame : self.originFrame
			detailView.frame = self.isPresenting ? fromView.frame : CGRect(x: toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
			detailView.alpha = self.isPresenting ? 1 : 0
		}, completion: { (finished) in
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
			transitionImageView.removeFromSuperview()
			artwork.alpha = 1
		})
	}
	
}
