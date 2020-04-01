//
//  DepartmentPopUpController.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 25/03/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import UIKit

class DepartmentPopUpController: UIViewController {
    
    @IBOutlet weak var departImage: UIImageView!
    @IBOutlet weak var departTitleLbl: UILabel!
    @IBOutlet weak var departContentLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var titleLbl: String!
    var contentLbl: String!
    var imageView: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //departTitleLbl.text = titleLbl
        departContentLbl.attributedText = contentLbl.htmlAttributed(family: "Dosis-Regular", size: 12, color: .label)
        departImage.image = imageView
        
        departImage.layer.cornerRadius = 10
        
        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: departContentLbl.bottomAnchor).isActive = true
        // Do any additional setup after loading the view.
        self.navigationItem.title = titleLbl
    }
}

extension String {
    func htmlAttributed(family: String?, size: CGFloat, color: UIColor) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: \(size)pt !important;" +
                "font-family: \(family ?? "Helvetica"), Helvetica !important;" +
            "}</style> \(self)"

            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }

            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
}
