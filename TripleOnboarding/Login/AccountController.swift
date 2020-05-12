//
//  AccountController.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 12/05/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import UIKit

class AccountController: UIViewController {

    @IBOutlet weak var logOutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func logOutBtn(_ sender: Any) {
        signOut(sender as! UIButton)
    }
    
}
