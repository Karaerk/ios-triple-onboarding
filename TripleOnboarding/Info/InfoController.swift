//
//  ViewController.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 03/03/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class InfoController: UIViewController {
    
    @IBOutlet weak private var UITitle: UILabel!
    @IBOutlet private var titleButtons: [UIButton]!
    
    private var ref: DatabaseReference!
    
    private var uiContent: [String] = []
    
    private var popUpTitle: String!
    private var popUpContent: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateContent()
    }
    
    func UpdateContent(){
        
        ref = Database.database().reference().child("info")
        var counter = 0
        
        ref.queryOrdered(byChild: "title").queryLimited(toLast: 4).observe(.childAdded) { (snapshot) in
            guard let firebaseResponse = snapshot.value as? [String:Any] else{
                return
            }
            
            let uiTitle = firebaseResponse["title"] as? String
            self.titleButtons[counter].setTitle(uiTitle, for: .normal)
            counter += 1
            
            //Puts everything from info/content in Array "uiContent"
            self.uiContent.append((firebaseResponse["content"] as? String)!)
        }
        
        for buttons in titleButtons{
            buttons.layer.cornerRadius = 25
        }
    }
    
    @IBAction func infoBtn(_ sender: UIButton) {
        self.popUpTitle = sender.title(for: .normal)
        
        //array uiContent is assigned to popUpContent
        self.popUpContent = uiContent[sender.tag]
        performSegue(withIdentifier: "Identifier", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let popUpVC = segue.destination as! PopUpViewController
        
        popUpVC.titleLbl = self.popUpTitle
        popUpVC.contentLbl = self.popUpContent
    }
    
}




