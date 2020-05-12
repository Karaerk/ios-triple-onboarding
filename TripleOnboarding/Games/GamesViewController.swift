//
//  GamesViewController.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 24/03/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import UIKit

class GamesViewController: UIViewController {
    
    @IBOutlet private var choiceBtns: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for buttons in choiceBtns{
            buttons.layer.cornerRadius = 50
        }
    }
    @IBAction func memoryBtn(_ sender: Any) {
        
        let loadAccount = DispatchGroup()
        loadAccount.enter()
        loadMSAL()
        loadAccount.leave()
        loadAccount.notify(queue: .main) {
            if loginSucces() {
                self.performSegue(withIdentifier: "memory", sender: nil)
            } else {
                let mainStoryboard:UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
                let homePage = mainStoryboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
                self.present(homePage, animated: true, completion: nil)
                homePage.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            }
        }
    }
}
