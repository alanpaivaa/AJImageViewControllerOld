//
//  AJScrollView.swift
//  AJImageViewController
//
//  Created by Alan Jeferson on 22/08/15.
//  Copyright (c) 2015 AJWorks. All rights reserved.
//

import UIKit

class AJScrollView: UIScrollView, UIScrollViewDelegate {
    
    var imageView: UIImageView!
    var minScale: CGFloat!
    
    init(frame: CGRect, imageView: UIImageView) {
        super.init(frame: frame)
        self.imageView = imageView
        self.setupViewAttrs()
        self.setupDoubleTapGesture()
        self.delegate = self
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewAttrs() -> Void {
        //Indicators and content size
        self.showsHorizontalScrollIndicator =  false
        self.showsVerticalScrollIndicator = false
        self.contentSize = self.imageView.bounds.size
        
        //Setting up the max an min zoomscales for not allowing to zoom out more than the image size
        let scrollViewFrame = self.frame
        let scaleWidth = scrollViewFrame.size.width / self.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / self.contentSize.height
        self.minScale = min(scaleWidth, scaleHeight)
        self.minimumZoomScale = self.minScale
        self.maximumZoomScale = 3.0
        self.zoomScale = self.minScale
        
        //Adding image
        self.addSubview(self.imageView)
    }
    
    func zoom(toScale scale: CGFloat, animated: Bool) -> Void {
        let scrollViewSize = self.bounds.size
        let w = scrollViewSize.width / scale
        let h = scrollViewSize.height / scale
        //        let x = self.view.center.x - (w/2.0)
        //        let y = self.view.center.y - (h/2.0)
        let rectToZoom = CGRect(x: 0.0, y: 0.0, width: w, height: h)
        self.zoomToRect(rectToZoom, animated: animated)
    }
    
    func centerImageView() -> Void {
        let boundsSize = self.bounds.size
        var contentFrame = self.imageView.frame
        
        if contentFrame.size.width < boundsSize.width {
            contentFrame.origin.x = (boundsSize.width - contentFrame.size.width) / 2.0
        } else {
            contentFrame.origin.x = 0.0
        }
        
        if contentFrame.size.height < boundsSize.height {
            contentFrame.origin.y = (boundsSize.height - contentFrame.size.height) / 2.0
        } else {
            contentFrame.origin.y = 0.0
        }
        
        self.imageView.frame = contentFrame
    }
    
    func setupDoubleTapGesture() -> Void {
        var doubleTapGesture = UITapGestureRecognizer(target: self, action: Selector("doubleTapScrollView:"))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.numberOfTouchesRequired = 1
        self.addGestureRecognizer(doubleTapGesture)
    }
    
    func doubleTapScrollView(tapGesture: UITapGestureRecognizer) -> Void {
        let pointInView = tapGesture.locationInView(self.imageView)
        
        var newZoomScale = self.zoomScale * 1.5
        newZoomScale = min(newZoomScale, self.maximumZoomScale)
        
        let scrollViewSize = self.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w/2.0)
        let y = pointInView.y - (h/2.0)
        
        let rectToZoom = CGRect(x: x, y: y, width: w, height: h)
        self.zoomToRect(rectToZoom, animated: true)
    }
    
    //MARK:- ScrollView Delegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
//    func scrollViewDidZoom(scrollView: UIScrollView) {
//        self.centerImageView()
//    }
    
}
