//
//  AJSingleImageViewController.swift
//  AJImageViewController
//
//  Created by Alan Jeferson on 22/08/15.
//  Copyright (c) 2015 AJWorks. All rights reserved.
//

import UIKit

class AJSingleImageViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var imageType = AJSingleImageViewControllerType.Normal
    var imageView: UIImageView!
    private var transition = AJSingleImageViewControllerTransition()
    
    init(imageView: UIImageView) {
        super.init(nibName: nil, bundle: nil)
        self.setupUIWith(imageView: imageView)
        self.setupGestureRecognizer()
        self.transition.referenceImageView = imageView
        self.transitioningDelegate = self
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupUIWith(#imageView: UIImageView) -> Void {
        self.view.backgroundColor = UIColor.blackColor()
        self.imageView = UIImageView(image: imageView.image)
        self.imageView.frame = imageView.frame
        self.imageView.contentMode = imageView.contentMode
        
//        if self.imageType == AJSingleImageViewControllerType.Circular {
//            self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2
//            self.imageView.layer.borderWidth = 2.0
//            self.imageView.layer.borderColor = UIColor.whiteColor().CGColor
//            self.imageView.clipsToBounds = true
//        }
        
        self.view.addSubview(self.imageView)
    }
    
    private func setupGestureRecognizer() -> Void {
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("viewDidTap:"))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func viewDidTap(tapGesture: UITapGestureRecognizer) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    //MARK:- UIViewControllerTransitioningDelegate methods
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.transition
    }
    
}