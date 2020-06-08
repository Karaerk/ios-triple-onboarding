//
//  PopUpViewController.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 04/03/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var contentLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var titleLbl: String!
    var contentLbl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleLbl
        contentLabel.text = contentLbl
        // Do any additional setup after loading the view.
        backButton.setImage(#imageLiteral(resourceName: "user-interface"), for: .normal)
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
