//
//  DepartmentPopUpController.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 25/03/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import UIKit

class DepartmentPopUpController: UIViewController {
    
    @IBOutlet weak private var departImage: UIImageView!
    @IBOutlet weak private var departTitleLbl: UILabel!
    @IBOutlet weak private var departContentLbl: UILabel!
    @IBOutlet weak private var scrollView: UIScrollView!
    
    
    var titleLbl: String!
    var contentLbl: String!
    var imageView: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //departTitleLbl.text = titleLbl
        departContentLbl.attributedText = contentLbl.htmlAttributed(family: "Dosis-Regular", size: 12, color: .label)
        departImage.image = imageView
        
        departImage.layer.cornerRadius = 10
        
        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: departContentLbl.bottomAnchor).isActive = true
        // Do any additional setup after loading the view.
        self.navigationItem.title = titleLbl
    }
}


