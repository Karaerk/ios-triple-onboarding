//
//  FAQpopupViewController.swift
//  TripleOnboarding
//
//  Created by Costa on 17/03/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import UIKit

class FAQpopupViewController: UIViewController {

        @IBOutlet weak var titleUI: UILabel!
        @IBOutlet weak var content: UILabel!
        @IBOutlet weak var popUpContainer: UIView!
        
        var titleLbl: String!
        var contentLbl: String!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            titleUI.text = titleLbl
            content.text = contentLbl
            popUpContainer.layer.cornerRadius = 15
            // Do any additional setup after loading the view.

        }

    }
