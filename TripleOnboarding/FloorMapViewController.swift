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
    @IBOutlet var floorBtns: [UIButton]!
    
    @IBAction func firstFloor(_ sender: UIButton) {
        if(self.imageView.image != UIImage(named: "Plattegrond 1e")){
            imageView.image = UIImage(named: "Plattegrond 1e")
        }
    }
    
    @IBAction func secondFloor(_ sender: UIButton) {
        imageView.image = UIImage(named: "Plattegrond 2e")
    }
    
    
    @IBAction func thirdFloor(_ sender: UIButton) {
        imageView.image = UIImage(named: "Plattegrond 3e")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scroll.delegate = self
        
        imageView.image = UIImage(named: "Plattegrond 1e")
        for buttons in floorBtns{
            buttons.layer.cornerRadius = 10
        }
    }

    /*
     function to zoom in on the image
     */
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}
