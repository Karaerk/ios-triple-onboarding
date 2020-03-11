//
//  FloorMapViewController.swift
//  TripleOnboarding
//
//  Created by Costa on 11/03/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import UIKit

class FloorMapViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scroll:UIScrollView!
    @IBOutlet weak var imageView:UIImageView!
 
    @IBAction func firstFloor(_ sender: UIButton) {
        if(self.imageView.image != UIImage(named: "Image")){
            imageView.image = UIImage(named: "Image")
        }
    }
    
    @IBAction func secondFloor(_ sender: UIButton) {
        imageView.image = UIImage(named: "image2")
    }
    
    
    @IBAction func thirdFloor(_ sender: UIButton) {
        imageView.image = UIImage(named: "image3")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scroll.delegate = self
    }

    /*
     function to zoom in on the image
     */
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}
