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
    
    var images = [UIImage]()
    var urls = [NSURL]()
    
    var pages = [AJScrollView?]()
    var currentPage = 0
    var loadedPagesOffset = 1
    let sideOffset: CGFloat = 10.0
    
    private var loadType: AJImageViewControllerLoadType!
    private var itensCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        self.setupPagging()
        self.addDismissButton()
    }
    
    func setupPagging() -> Void {
        self.scrollView.delegate = self
        
        self.images.append(UIImage(named: "jake")!)
        self.images.append(UIImage(named: "fin")!)
        self.images.append(UIImage(named: "iceKing")!)
        
        self.urls.append(NSURL(string: "http://myguitar.com.br/wp-content/uploads/2015/03/kiko-loureiro-angra-entrevista-my-guitar.jpg")!)
        self.urls.append(NSURL(string: "http://wikimetal.com.br/site/wp-content/uploads/2013/10/Yngwie.jpg")!)
        self.urls.append(NSURL(string: "https://c1.staticflickr.com/9/8004/7166837179_bfa07fd7b5_b.jpg")!)
        
        self.loadType = AJImageViewControllerLoadType.LoadFromLocalImages
        
        self.setupItemCount()
        
        for _ in 0..<self.itensCount {
            self.pages.append(nil)
        }
        
        //Setup the side offset to give a blank space between each image
        self.scrollView.frame.size.width += 2*self.sideOffset
        self.scrollView.frame.origin.x -= self.sideOffset
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width * CGFloat(self.itensCount), height: self.scrollView.frame.size.height)
        
        self.loadVisiblePages()
    }
    
    private func setupItemCount() -> Void {
        if self.loadType == AJImageViewControllerLoadType.LoadFromLocalImages {
            self.itensCount = self.images.count
        } else {
            self.itensCount = self.urls.count
        }
    }
    
    func load(#page: Int) -> Void {
        
        if page>=0 && page<self.itensCount {
            
            if self.pages[page] == nil {
                //Init inside image and scroll
                var frame = self.scrollView.frame
                frame.origin.x = CGFloat(page) * self.scrollView.frame.width
                frame.origin.x += self.sideOffset
                frame.size.width -= 2*self.sideOffset
                
                var insideScroll: AJScrollView!
                var imageForZooming: UIImageView
                
                if self.loadType == AJImageViewControllerLoadType.LoadFromLocalImages {
                    insideScroll = AJScrollView(frame: frame, image: self.images[page])
                } else {
                    insideScroll = AJScrollView(frame: frame, url: self.urls[page])
                }
                
                //Adding subviews
                self.scrollView.addSubview(insideScroll)
                
                self.pages[page] = insideScroll
            }
        }
    }
    
    func purge(#page: Int) -> Void {
        if page>=0 && page<self.itensCount {
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
        
        for var index = lastPage+1; index<self.itensCount; ++index {
            self.purge(page: index)
        }
    }
    
    private func addDismissButton() -> Void {
        let buttonSize: CGFloat = 44.0
        let buttonOffset: CGFloat = 5.0
        let buttonInset: CGFloat = 12.0
        let button = UIButton(frame: CGRect(x: buttonOffset, y: buttonOffset, width: buttonSize, height: buttonSize))
        button.contentEdgeInsets = UIEdgeInsets(top: buttonInset, left: buttonInset, bottom: buttonInset, right: buttonInset)
        button.setImage(UIImage(named: "delete"), forState: UIControlState.Normal)
        button.addTarget(self, action: Selector("dismissViewController:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }
    
    func dismissViewController(sender: UIButton) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //MARK:- ScrollView delegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var page = Int(self.scrollView.contentOffset.x / self.scrollView.frame.width)
        if page != self.currentPage {
            self.currentPage = page
            self.loadVisiblePages()
        }
    }
}

