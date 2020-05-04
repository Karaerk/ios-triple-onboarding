//
//  UrenboekNewPageController.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 01/04/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import UIKit
import SafariServices

class HourNewPageController: UIViewController {

    @IBOutlet weak private var contentLblUI: UILabel!
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var button: UIButton!
    
    var contentLbl: String!
    var titleLbl: String!
    //Is tijdelijk, moet nog worden opgehaald van database
    private let hourWebsite = URL(string: "https://app.wearetriple.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        button.layer.cornerRadius = 20
        contentLblUI.attributedText = contentLbl.htmlAttributed(family: "Dosis-Regular", size: 12, color: .label)
        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: contentLblUI.bottomAnchor).isActive = true
        self.navigationItem.title = titleLbl
    }
    //Laat internet pagina laden in de app zelf
    @IBAction func websiteBtn(_ sender: UIButton) {
        let vc = SFSafariViewController(url: hourWebsite!)
        present(vc, animated: true, completion: nil)
    }
}
