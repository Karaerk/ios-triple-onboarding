//
//  DepartmentPopUpController.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 25/03/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import UIKit
import Nuke

class DepartmentPopUpController: UIViewController {
    
    @IBOutlet weak private var departImage: UIImageView!
    @IBOutlet weak private var departTitleLbl: UILabel!
    @IBOutlet weak private var departContentLbl: UILabel!
    @IBOutlet weak private var scrollView: UIScrollView!
    
    var titleLbl: String!
    var contentLbl: String!
    var imageView: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateContent()
    }
    
    func updateContent() {
        let image = ImageRequest(url: imageView, processors: [
            ImageProcessors.Resize(size: departImage.bounds.size)
        ])
        
        let options = ImageLoadingOptions(
            placeholder: #imageLiteral(resourceName: "Triple Logo"),
            transition: .fadeIn(duration: 0.33)
        )
        
        Nuke.loadImage(with: image, options: options, into: departImage)
        
        departImage.layer.cornerRadius = 10
        departContentLbl.attributedText = contentLbl.htmlAttributed(family: "Dosis-Regular", size: 12, color: .label)
        
        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: departContentLbl.bottomAnchor).isActive = true
        self.navigationItem.title = titleLbl
    }
}


