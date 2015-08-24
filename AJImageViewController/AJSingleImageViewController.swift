//
//  AJSingleImageViewController.swift
//  AJImageViewController
//
//  Created by Alan Jeferson on 22/08/15.
//  Copyright (c) 2015 AJWorks. All rights reserved.
//

import UIKit

class AJSingleImageViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var imageView: UIImageView!
    private var transition = AJSingleImageViewControllerTransition()
    
    init(imageView: UIImageView, imageWidth: CGFloat = UIScreen.mainScreen().bounds.size.width, shouldBounce: Bool? = nil, transitionDuration: NSTimeInterval? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.setupUIWith(imageView: imageView)
        self.setupGestureRecognizer()
        self.transition.referenceImageView = imageView
        self.transition.imageWidth = imageWidth
        if let shouldBounce = shouldBounce {
            self.transition.shouldBounce = shouldBounce
        }
        if let transitionDuration = transitionDuration {
            self.transition.duration = transitionDuration
        }
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
        self.imageView.layer.cornerRadius = imageView.layer.cornerRadius
        self.imageView.clipsToBounds = imageView.clipsToBounds
        
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
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //MARK:- UIViewControllerTransitioningDelegate methods
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.transition
    }
    
}