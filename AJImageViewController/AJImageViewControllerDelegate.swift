//
//  AJImageViewControllerDelegate.swift
//  AJImageViewController
//
//  Created by Alan Jeferson on 22/08/15.
//  Copyright (c) 2015 AJWorks. All rights reserved.
//

import UIKit

extension MainViewController: UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
}
