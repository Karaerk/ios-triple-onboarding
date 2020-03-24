//
//  GamesViewController.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 24/03/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import UIKit

class GamesViewController: UIViewController {

    @IBOutlet var choiceBtns: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for buttons in choiceBtns{
            buttons.layer.cornerRadius = 50
        }
    }
    

}
