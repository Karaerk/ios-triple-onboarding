//
//  String+Extension.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 10/04/2020.
//  Copyright © 2020 Triple. All rights reserved.
//


import UIKit

public extension String {
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
