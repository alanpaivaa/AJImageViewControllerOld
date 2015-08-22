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
    var pages = [AJScrollView?]()
    var innerScrollFrame: CGRect!
    var lastOffset: CGFloat = 0
    var currentPage = 0
    
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
        
        for _ in 0..<self.images.count {
            self.pages.append(nil)
        }
        
        self.innerScrollFrame = self.scrollView.bounds
        
//        for i in 0..<self.images.count {
//            //Init inside image
//            let imageForZooming = UIImageView(image: self.images[i])
//            
//            //Init inside scroll that holds the image
//            let insideScroll = AJScrollView(frame: innerScrollFrame, imageView: imageForZooming)
//            
//            //Adding subviews
//            self.scrollView.addSubview(insideScroll)
//            
//            //Zooming to aspect fit the screen
//            insideScroll.zoom(toScale: insideScroll.minScale, animated: false)
//            
//            //Centering the image
//            insideScroll.centerImageView()
//            
//            //Incrementing the inner rect origin to hold the next scroll in the right position
//            innerScrollFrame.origin.x += innerScrollFrame.size.width
//            
//        }
//        
//        self.scrollView.contentSize = CGSize(width: innerScrollFrame.origin.x, height: self.scrollView.bounds.size.height)
        
        self.loadVisiblePages()
    }
    
    func load(#page: Int) -> Void {
        
        if page>=0 && page<self.images.count {
            if self.pages[page] == nil {
                
                //Init inside image
                let imageForZooming = UIImageView(image: self.images[page])
                
                //Init inside scroll that holds the image
                let insideScroll = AJScrollView(frame: innerScrollFrame, imageView: imageForZooming)
                insideScroll.tag = page
                
                //Adding subviews
                self.scrollView.addSubview(insideScroll)
                
                //Zooming to aspect fit the screen
                insideScroll.zoom(toScale: insideScroll.minScale, animated: false)
                
                //Centering the image
                insideScroll.centerImageView()
                
                //Incrementing the inner rect origin to hold the next scroll in the right position
                innerScrollFrame.origin.x += innerScrollFrame.size.width
                
                self.scrollView.contentSize = CGSize(width: innerScrollFrame.origin.x, height: self.scrollView.bounds.size.height)
                
                self.pages[page] = insideScroll
            }
        }
    }
    
    func purge(#page: Int) -> Void {
        if page>=0 && page<self.images.count {
            if let pageView = self.pages[page] {
                pageView.removeFromSuperview()
                self.pages[page] = nil
            }
        }
    }
    
    func loadVisiblePages() -> Void {
        let firstPage = self.currentPage - 1
        let lastPage = self.currentPage + 1
        
//        for var index = 0; index<firstPage; ++index {
//            self.purge(page: index)
//        }
        
        for index in firstPage...lastPage {
            self.load(page: index)
        }
        
//        for var index = lastPage+1; index<self.images.count; ++index {
//            self.purge(page: index)
//        }
    }
    
    //MARK:- ScrollView delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        self.loadVisiblePages()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var page = self.currentPage
        if self.scrollView.contentOffset.x > self.lastOffset {
            page++
        } else if self.scrollView.contentOffset.x < self.lastOffset {
            page--
        }
        if page != self.currentPage {
            self.currentPage = page
            self.loadVisiblePages()
            self.lastOffset = self.scrollView.contentOffset.x
        }
    }
}

