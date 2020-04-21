//
//  FactsPopUpController.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 17/03/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import UIKit
//Wordt gebruikt door FAQ en Facts
class PopUpController: UIViewController {

    @IBOutlet weak private var titleUI: UILabel!
    @IBOutlet weak private var content: UILabel!
    @IBOutlet weak private var popUpContainer: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    var titleLbl: String!
    var contentLbl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleUI.text = titleLbl
        content.text = contentLbl
        popUpContainer.layer.cornerRadius = 15
        backButton.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
