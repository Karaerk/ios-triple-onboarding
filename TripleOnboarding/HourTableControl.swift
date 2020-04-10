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

struct ProjectCode{
    var code: String
    var content: String
}

class HourTableControl: UITableViewController {          //Algemene projectcodes scherm
    
    private var projectcode = [ProjectCode]()
    private var ref: DatabaseReference!
    
    private var hourPUCode: String!
    private var hourPUContent: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateContent()
    }
    //Appends all code and content to a struct
    func updateContent(){
        Database.database().reference().child("/hours/1/child/")
            .observe(.childAdded) { (snapshot) in
                guard let firebaseResponse = snapshot.value as? [String:Any] else{
                    return
                }
                let codeTitle = (firebaseResponse["code"] as? String)!
                let codeContent = (firebaseResponse["content"] as? String)!
                //Struct is used in tableview func
                self.projectcode.append(ProjectCode(code: codeTitle, content: codeContent))
                self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectcode.count
    }
    //For every "code" in struct tableview will show it
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CodeCell", for: indexPath)
        let content = projectcode[indexPath.row]
        cell.textLabel?.text = content.code
        cell.textLabel?.font = UIFont(name: "Dosis-Regular", size: 20)
        cell.textLabel?.minimumScaleFactor = 10/UIFont.labelFontSize
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        return cell
    }
    //When row is selected urenPUCode = code & UrenPUContent = content (All from struct)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = projectcode[indexPath.row]
        hourPUCode = content.code
        hourPUContent = content.content
        performSegue(withIdentifier: "UrenboekPopUp", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "UrenboekPopUp") {
            let popUpVC = segue.destination as! HourPopUpContrl
            popUpVC.titleLbl = self.hourPUCode
            popUpVC.contentLbl = self.hourPUContent
        }
    }
}
