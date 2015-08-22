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
    
    var images = [UIImage]()
    var imageViews = [UIImageView?]()
    var innerScrollFrame: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
//        self.setupImageView()
//        self.setupScrollView()
        self.setupPagging()
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
        
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        v.backgroundColor = UIColor.greenColor()
        self.scrollView.addSubview(v)
        
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
        
        self.scrollView.maximumZoomScale = 3.0
        self.scrollView.zoomScale = minScale
        
//        self.centerScrollViewContents()
        
    }
    
    func center(#imageView: UIImageView, ofScrollView scrollView: UIScrollView) -> Void {
        let boundsSize = scrollView.bounds.size
        var contentFrame = imageView.frame
        
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
    
    func zoom(#scrollView: UIScrollView, toScale scale: CGFloat, animated: Bool) -> Void {
        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / scale
        let h = scrollViewSize.height / scale
//        let x = self.view.center.x - (w/2.0)
//        let y = self.view.center.y - (h/2.0)
        let rectToZoom = CGRect(x: 0.0, y: 0.0, width: w, height: h)
        scrollView.zoomToRect(rectToZoom, animated: animated)
    }
    
    func setupPagging() -> Void {
        self.scrollView.delegate = self
        
        self.images.append(UIImage(named: "jake")!)
        self.images.append(UIImage(named: "fin")!)
        self.images.append(UIImage(named: "iceKing")!)
        
        self.innerScrollFrame = self.scrollView.bounds
        
        for i in 0..<self.images.count {
            //Init inside image
            let imageForZooming = UIImageView(image: self.images[i])
            imageForZooming.tag = 11
            
            //Init inside scroll that holds the image
            let insideScroll = UIScrollView(frame: innerScrollFrame)
            insideScroll.showsHorizontalScrollIndicator =  false
            insideScroll.showsVerticalScrollIndicator = false
            insideScroll.contentSize = imageForZooming.bounds.size
            insideScroll.delegate = self
            
            //Setting up the max an min zoomscales for not allowing to zoom out more than the image size
            let scrollViewFrame = insideScroll.frame
            let scaleWidth = scrollViewFrame.size.width / insideScroll.contentSize.width
            let scaleHeight = scrollViewFrame.size.height / insideScroll.contentSize.height
            let minScale = min(scaleWidth, scaleHeight)
            insideScroll.minimumZoomScale = minScale
            insideScroll.maximumZoomScale = 3.0
            insideScroll.zoomScale = minScale
            
            //Adding subviews
            insideScroll.addSubview(imageForZooming)
            self.scrollView.addSubview(insideScroll)
            
            //Zooming to aspect fit the screen
            self.zoom(scrollView: insideScroll, toScale: minScale, animated: false)
            
            //Centering the image
            self.center(imageView: imageForZooming, ofScrollView: insideScroll)
            
            //Incrementing the inner rect origin to hold the next scroll in the right position
            innerScrollFrame.origin.x += innerScrollFrame.size.width
            
        }
        
        self.scrollView.contentSize = CGSize(width: innerScrollFrame.origin.x, height: self.scrollView.bounds.size.height)
        
//        self.loadVisiblePages()
    }
    
    func load(#page: Int) -> Void {
        if page>=0 && page<self.images.count {
            if self.imageViews[page] == nil {
//                //Page already loaded
//                var frame = self.scrollView.bounds
//                frame.origin.x = frame.size.width * CGFloat(page)
//                frame.origin.y = 0.0
                var origin = CGPoint(x: self.images[page].size.width * CGFloat(page), y: 0.0)
//
//                let newPageView = UIImageView(image: self.images[page])
////                newPageView.contentMode = UIViewContentMode.ScaleAspectFit
//                newPageView.frame.origin.x = frame.origin.x
//                newPageView.frame.origin.y = 0.0
//                self.scrollView.contentSize = newPageView.frame.size
//                self.scrollView.addSubview(newPageView)
//                
//                self.imageViews[page] = newPageView
//                
//                self.scrollView.delegate = self
//                self.scrollView.zoomScale = 2.0
                
                self.imageView = UIImageView(image: self.images[page])
                self.imageView.frame = CGRect(origin: origin, size: self.images[page].size)
                self.scrollView.addSubview(self.imageView)
                
                self.scrollView.delegate = self
                
                //Setup double tap gesture
//                self.scrollView.contentSize = self.imageView.frame.size
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
                
                self.scrollView.maximumZoomScale = 3.0
                self.scrollView.zoomScale = minScale
                
//                self.centerScrollViewContents()
            }
        }
    }
    
    func purge(#page: Int) -> Void {
        if page>=0 && page<self.images.count {
            if let pageView = self.imageViews[page] {
                pageView.removeFromSuperview()
                self.imageViews[page] = nil
            }
        }
    }
    
    func loadVisiblePages() -> Void {
        let pageWidth = self.scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        let firstPage = page - 1
        let lastPage = page + 1
        
        for var index = 0; index<firstPage; ++index {
            self.purge(page: index)
        }
        
        for index in firstPage...lastPage {
            self.load(page: index)
        }
        
        for var index = lastPage+1; index<self.images.count; ++index {
            self.purge(page: index)
        }
    }
    
    //MARK:- ScrollView delegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
//        return self.imageView
        return scrollView.viewWithTag(11)
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
//        self.centerScrollViewContents()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        self.loadVisiblePages()
    }
}

