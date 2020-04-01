//
//  UrenboekTableContrl.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 01/04/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

struct projectCodes{
    var code: String
    var content: String
}

class UrenboekTableContrl: UITableViewController {
    
    var projectcode = [projectCodes]()
    var ref: DatabaseReference!
    
    var urenPUCode: String!
    var urenPUContent: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateContent()
    }
    
    func updateContent(){
        ref = Database.database().reference().child("urenboek")
        
        ref.child("projectcodes").queryOrdered(byChild: "code").observe(.childAdded) { (snapshot) in
            guard let firebaseResponse = snapshot.value as? [String:Any] else{
                return
            }
            let codeTitle = (firebaseResponse["code"] as? String)!
            let codeContent = (firebaseResponse["content"] as? String)!
            
            self.projectcode.append(projectCodes(code: codeTitle, content: codeContent))
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectcode.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CodeCell", for: indexPath)
        let content = projectcode[indexPath.row]
        cell.textLabel?.text = content.code
        cell.textLabel?.font = UIFont(name: "Dosis-Regular", size: 20)
        cell.textLabel?.minimumScaleFactor = 10/UIFont.labelFontSize
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = projectcode[indexPath.row]
        urenPUCode = content.code
        urenPUContent = content.content
        performSegue(withIdentifier: "UrenboekPopUp", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "UrenboekPopUp") {
            let popUpVC = segue.destination as! UrenboekPopUpContrl
            popUpVC.titleLbl = self.urenPUCode
            popUpVC.contentLbl = self.urenPUContent
        }
    }
}
