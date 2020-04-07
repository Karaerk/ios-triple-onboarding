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

struct urenBoekContent{
    var title: String
    var content: String
}
class UrenboekController: UIViewController {            //BEGIN SCHERM URENBOEK
    
    var urenContents = [urenBoekContent]()
    var ref: DatabaseReference!
    
    var titleNPage: String!
    var contentNPage: String!
    
    @IBOutlet var urenBoekBtns: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Layout for buttons
        for buttons in urenBoekBtns{
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
            let urenTitle = (firebaseResponse["title"] as? String)!
            let urenContent = (firebaseResponse["content"] as? String)!
            self.urenContents.append(urenBoekContent(title: urenTitle, content: urenContent))
        }
    }
    //Button for "Hoe boek je uren" & "Uren registratie"
    @IBAction func choiceBtns(_ sender: UIButton) {
        let urenContent = urenContents[sender.tag]
        titleNPage = urenContent.title
        contentNPage = urenContent.content
        performSegue(withIdentifier: "UrenboekPage", sender: self)
    }
    //Button for "algemene projectcodes"
    @IBAction func projectCodeBtn(_ sender: Any) {
        performSegue(withIdentifier: "UrenboekTable", sender: self)
    }
    //Prepare seque for the buttons
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UrenboekPage"{
            let popUpVC = segue.destination as! UrenboekNewPageController
            popUpVC.titleLbl = self.titleNPage
            popUpVC.contentLbl = self.contentNPage
        } else if segue.identifier == "UrenboekTable" {
            //let urenTable = segue.destination as! UrenboekTableContrl
        }
        
    }

    
}
