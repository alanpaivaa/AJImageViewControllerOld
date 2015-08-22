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
        self.setupPagging()
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
            
            //Init inside scroll that holds the image
            let insideScroll = AJScrollView(frame: innerScrollFrame, imageView: imageForZooming)
            
            //Adding subviews
            self.scrollView.addSubview(insideScroll)
            
            //Zooming to aspect fit the screen
            insideScroll.zoom(toScale: insideScroll.minScale, animated: false)
            
            //Centering the image
            insideScroll.centerImageView()
            
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
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        self.loadVisiblePages()
    }
}

