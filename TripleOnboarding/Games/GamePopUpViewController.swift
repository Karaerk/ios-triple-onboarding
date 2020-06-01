//
//  GamePopUpViewController.swift
//  TripleOnboarding
//
//  Created by Costa van Elsas on 07/04/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import UIKit

class GamePopUpViewController: UIViewController {
    
    @IBOutlet weak private var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    var scoreLbl: String!
    var contentLbl: String!
    var highScoreLbl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = scoreLbl
        highScoreLabel.text = highScoreLbl
        
        //hide the back button
        self.navigationItem.hidesBackButton = true
    }
    
    //function to to return too the gamesview when close is pressed
    @IBAction func CloseBtn(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }

}
