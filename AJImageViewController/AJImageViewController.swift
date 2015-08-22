//
//  ViewController.swift
//  AJImageViewController
//
//  Created by Alan Jeferson on 21/08/15.
//  Copyright (c) 2015 AJWorks. All rights reserved.
//

import UIKit

class AJImageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        self.setupImageView()
        self.setupScrollView()
    }
    
    func setupImageView() -> Void {
        let image = UIImage(named: "jake")
        if let image = image {
            self.imageView = UIImageView(image: image)
            self.imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: image.size)
            self.scrollView.addSubview(self.imageView)
        }
    }
    
    func setupScrollView() -> Void {
        self.scrollView.delegate = self
        self.scrollView.bounces = false
        
        //Setup double tap gesture
        self.scrollView.contentSize = self.imageView.frame.size
        var doubleTapGesture = UITapGestureRecognizer(target: self, action: Selector("doubleTapScrollView:"))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.numberOfTouchesRequired = 1
        self.scrollView.addGestureRecognizer(doubleTapGesture)
        
        //Setup scroll view first scale
        let scrollViewFrame = self.scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight)
        self.scrollView.minimumZoomScale = minScale
        
        self.scrollView.maximumZoomScale = 1.0
        self.scrollView.zoomScale = minScale
        
        self.centerScrollViewContents()
    }
    
    func centerScrollViewContents() -> Void {
        let boundsSize = self.scrollView.bounds.size
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
        
        imageView.frame = contentFrame
    }
    
    func doubleTapScrollView(tapGesture: UITapGestureRecognizer) -> Void {
        let pointInView = tapGesture.locationInView(self.imageView)
        
        var newZoomScale = self.scrollView.zoomScale * 1.5
        newZoomScale = min(newZoomScale, self.scrollView.maximumZoomScale)
        
        let scrollViewSize = self.scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w/2.0)
        let y = pointInView.y - (h/2.0)
        
        let rectToZoom = CGRect(x: x, y: y, width: w, height: h)
        self.scrollView.zoomToRect(rectToZoom, animated: true)
        
    }
    
    
    //MARK:- ScrollView delegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        self.centerScrollViewContents()
    }
}

