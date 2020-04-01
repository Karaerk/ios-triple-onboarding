//
//  UrenboekNewPageController.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 01/04/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import UIKit
import SafariServices

class UrenboekNewPageController: UIViewController {

    @IBOutlet weak var contentLblUI: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var button: UIButton!
    
    var contentLbl: String!
    var titleLbl: String!
    
    let urenWebsite = URL(string: "https://uren.wearetriple.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        button.layer.cornerRadius = 20
        contentLblUI.text = contentLbl
        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: contentLblUI.bottomAnchor).isActive = true
        self.navigationItem.title = titleLbl
    }

    @IBAction func websiteBtn(_ sender: UIButton) {
        let vc = SFSafariViewController(url: urenWebsite!)
        present(vc, animated: true, completion: nil)
    }
}
