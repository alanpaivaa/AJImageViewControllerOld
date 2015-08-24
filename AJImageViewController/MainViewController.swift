//
//  MainViewController.swift
//  AJImageViewController
//
//  Created by Alan Jeferson on 22/08/15.
//  Copyright (c) 2015 AJWorks. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGestureRecognizer()
    }
    
    func setupGestureRecognizer() -> Void {
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("presentImageViewController:"))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.imageView.userInteractionEnabled = true
        self.imageView.addGestureRecognizer(tapGesture)
    }
    
    func presentImageViewController(gesture: UITapGestureRecognizer) -> Void {
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        if let imageController = storyBoard.instantiateViewControllerWithIdentifier("AJImageViewController") as? AJImageViewController {
            self.presentViewController(imageController, animated: true, completion: nil)
        }
//        let singleImageController = AJSingleImageViewController(imageView: self.imageView)
//        self.presentViewController(singleImageController, animated: true, completion: nil)
    }
    
}
