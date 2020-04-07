//
//  GamePopUpViewController.swift
//  TripleOnboarding
//
//  Created by Costa van Elsas on 07/04/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import UIKit

class GamePopUpViewController: UIViewController {
    
    @IBOutlet weak var ScoreLabel: UILabel!
    
    var scoreLbl: String!
    var contentLbl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScoreLabel.text = scoreLbl
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func CloseBtn(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }

}
