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
    var currentPage = 0
    var loadedPagesOffset = 1
    
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
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.width * CGFloat(self.images.count), height: self.scrollView.bounds.size.height)
        
        self.loadVisiblePages()
    }
    
    func load(#page: Int) -> Void {
        
        if page>=0 && page<self.images.count {
            
            if self.pages[page] == nil {
                //Init inside image
                let imageForZooming = UIImageView(image: self.images[page])
                
                //Init inside scroll that holds the image
                var frame = self.scrollView.bounds
                frame.origin.x = CGFloat(page) * self.scrollView.bounds.width
                let insideScroll = AJScrollView(frame: frame, imageView: imageForZooming)
                insideScroll.tag = page
                
                //Adding subviews
                self.scrollView.addSubview(insideScroll)
                
                //Zooming to aspect fit the screen
                insideScroll.zoom(toScale: insideScroll.minScale, animated: false)
                
                //Centering the image
                insideScroll.centerImageView()
                
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
        let firstPage = self.currentPage - self.loadedPagesOffset
        let lastPage = self.currentPage + self.loadedPagesOffset
        
        for var index = 0; index<firstPage; ++index {
            self.purge(page: index)
        }
        
        for i in firstPage...lastPage {
            self.load(page: i)
        }
        
        for var index = lastPage+1; index<self.images.count; ++index {
            self.purge(page: index)
        }
    }
    
    //MARK:- ScrollView delegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var page = Int(self.scrollView.contentOffset.x / self.scrollView.bounds.width)
        if page != self.currentPage {
            self.currentPage = page
            self.loadVisiblePages()
        }
    }
}

