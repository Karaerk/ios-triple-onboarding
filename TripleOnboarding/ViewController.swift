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

class ViewController: UIViewController {
    
    @IBOutlet weak var UITitle: UILabel!
    @IBOutlet var titleButtons: [UIButton]!
    
    var ref: DatabaseReference!
    var myref: DatabaseReference!
    
    var uiTitle: String!
    var popUpTitle: String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UpdateUI()
    }
    
    
    
    func UpdateUI(){
        
        ref = Database.database().reference()
        myref = ref.child("info")
        var counter = 0
        
        myref.queryOrdered(byChild: "title").queryLimited(toLast: 5).observe(.childAdded) { (snapshot) in
            guard let firebaseResponse = snapshot.value as? [String:Any] else{
                return
            }
            
            self.uiTitle = firebaseResponse["title"] as? String
            //            let title = firebaseResponse["title"] as! String
            
            self.titleButtons[counter].setTitle(self.uiTitle, for: .normal)
            counter += 1
        }
    }
    
    @IBAction func infoBtn(_ sender: UIButton) {
        self.popUpTitle = sender.title(for: .normal)
        performSegue(withIdentifier: "Identifier", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PopUpViewController
        vc.titleLbl = self.popUpTitle
    }
    
}




