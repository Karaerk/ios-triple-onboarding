//
//  UrenboekController.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 01/04/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

struct HourContent{
    var title: String
    var content: String
}
enum SegueIdentifier: String{
    case UrenboekPage
    case UrenboekTable
}
class HourController: UIViewController {            //BEGIN SCHERM URENBOEK
    
    private var hourContents = [HourContent]()
    private var ref: DatabaseReference!
    
    private var titleNPage: String!
    private var contentNPage: String!
    
    @IBOutlet private var hourBtns: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Layout for buttons
        for buttons in hourBtns{
            buttons.layer.cornerRadius = 50     
        }
        updateContent()
    }
    //Puts all te titles with content in the "urenboekContent" Struct
    func updateContent(){
        ref = Database.database().reference().child("hours")
        
        ref.observe(.childAdded) { (snapshot) in
            guard let firebaseResponse = snapshot.value as? [String:Any] else{
                return
            }
            let hourTitle = (firebaseResponse["title"] as? String)!
            let hourContent = (firebaseResponse["content"] as? String)!
            self.hourContents.append(HourContent(title: hourTitle, content: hourContent))
        }
    }
    //Button for "Hoe boek je uren" & "Uren registratie"
    @IBAction func choiceBtns(_ sender: UIButton) {
        let hourContent = hourContents[sender.tag]
        titleNPage = hourContent.title
        contentNPage = hourContent.content
        performSegue(withIdentifier: SegueIdentifier.UrenboekPage.rawValue, sender: self)
    }
    //Button for "algemene projectcodes"
    @IBAction func projectCodeBtn(_ sender: Any) {
        performSegue(withIdentifier: SegueIdentifier.UrenboekTable.rawValue, sender: self)
    }
    //Prepare seque for the buttons
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, let SegueIdentifier = SegueIdentifier(rawValue: identifier) {
            switch SegueIdentifier {
            case .UrenboekPage:
                let popUpVC = segue.destination as! HourNewPageController
                popUpVC.titleLbl = self.titleNPage
                popUpVC.contentLbl = self.contentNPage
            case .UrenboekTable:
                return
                //let urenTable = segue.destination as! HourPopUpContrl
            }
        }
    }
}
