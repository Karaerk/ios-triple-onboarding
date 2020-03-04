//
//  PopUpViewController.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 04/03/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    var titleLbl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleLbl
        // Do any additional setup after loading the view.
    }
}
