//
//  FloorMapViewController.swift
//  TripleOnboarding
//
//  Created by hva_1 on 11/03/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import UIKit

class FloorMapViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scroll:UIScrollView!
    @IBOutlet weak var imageView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scroll.delegate = self
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}

