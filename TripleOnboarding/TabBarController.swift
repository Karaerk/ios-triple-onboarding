//
//  TabBarController.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 24/03/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    private let pinkColor = UIColor(red: 236/255, green: 102/255, blue: 118/255, alpha: 1)
    private let blueColor = UIColor(red: 20/255, green: 32/255, blue: 67/255, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = blueColor

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
