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
        let imageViewController = AJImageViewController(images: UIImage(named: "jake")!, UIImage(named: "fin")!, UIImage(named: "iceKing")!)
//        let imageViewController = AJImageViewController(urls: NSURL(string: "http://myguitar.com.br/wp-content/uploads/2015/03/kiko-loureiro-angra-entrevista-my-guitar.jpg")!, NSURL(string: "http://wikimetal.com.br/site/wp-content/uploads/2013/10/Yngwie.jpg")!, NSURL(string: "https://c1.staticflickr.com/9/8004/7166837179_bfa07fd7b5_b.jpg")!)
        self.presentViewController(imageViewController, animated: true, completion: nil)
//        let singleImageController = AJSingleImageViewController(imageView: self.imageView)
//        self.presentViewController(singleImageController, animated: true, completion: nil)
    }
    
}
