//
//  AccountController.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 12/05/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import UIKit
import MSAL

class AccountController: UIViewController {
    
    
    @IBOutlet weak var logOutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    @IBAction func signOutBtn(_ sender: Any) {
        controller = self
        print(controller! as UIViewController)
        signOut(sender as! UIButton)
    }
}
