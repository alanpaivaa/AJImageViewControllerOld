//
//  AJImageViewControllerTransition.swift
//  AJImageViewController
//
//  Created by Alan Jeferson on 22/08/15.
//  Copyright (c) 2015 AJWorks. All rights reserved.
//

import UIKit

class AJImageViewControllerTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration: NSTimeInterval = 0.85
    var presenting = true
    var originFrame = CGRect.zeroRect
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return self.duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView()
        let fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! MainViewController
        let toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! AJImageViewController
        
        toView.view.hidden = true
        toView.view.frame.origin = CGPoint(x: 0, y: 0)
        containerView.addSubview(toView.view)
        
        let backgroundView = UIView(frame: fromView.view.bounds)
        backgroundView.backgroundColor = toView.view.backgroundColor
        backgroundView.alpha = 0
        containerView.addSubview(backgroundView)
        
        containerView.addSubview(fromView.imageView)
        
        let factor = toView.view.frame.size.width / fromView.imageView.frame.size.width
        
        UIView.animateWithDuration(self.duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            fromView.imageView.transform = CGAffineTransformMakeScale(factor, factor)
            fromView.imageView.center = fromView.view.center
            backgroundView.alpha = 1
        }) { (_) -> Void in
            toView.view.hidden = false
            containerView.bringSubviewToFront(toView.view)
            transitionContext.completeTransition(true)
        }
        
    }
    
}
