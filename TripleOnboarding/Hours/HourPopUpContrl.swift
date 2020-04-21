//
//  UrenboekPopUpContrl.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 01/04/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import UIKit

class HourPopUpContrl: UIViewController {           //Pop up for hoe boek je uren & uren registratie

    @IBOutlet weak private var titleLblUI: UILabel!
    @IBOutlet weak private var contentLblUI: UILabel!
    
    var titleLbl: String!
    var contentLbl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLblUI.text = titleLbl
        contentLblUI.text = contentLbl
    }

}
