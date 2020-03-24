//
//  FAQTableViewController.swift
//  TripleOnboarding
//
//  Created by Costa on 17/03/2020.
//  Copyright © 2020 Triple. All rights reserved.
//
import Foundation
import UIKit
import FirebaseDatabase

class FAQTableViewController: UITableViewController {
    
    var ref: DatabaseReference!
    var myref: DatabaseReference!
    
    var questions : [String] = []
    var answers : [String] = []
    
    var popUpTitle: String!
    var popUpContent: String!
    
    var rowHeight : CGFloat = 75
    var fontSize : CGFloat = 25
    
    let pinkColor = UIColor(red: 236/255, green: 102/255, blue: 118/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        updateContent()
    }
    
    func updateContent(){
        
        ref = Database.database().reference()
        myref = ref.child("faq")
        
        myref.queryOrdered(byChild: "question").observe(.childAdded) { (snapshot) in
            guard let firebaseResponse = snapshot.value as? [String:Any] else{
                return
            }
            
            self.questions.append((firebaseResponse["question"] as? String)!)
            self.answers.append((firebaseResponse["answer"] as? String)!)
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath)
        cell.textLabel?.text = questions[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont(name: "Dosis-Regular", size: 25)
        cell.textLabel?.textColor = UIColor.white
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 0, y: 10, width: self.view.frame.size.width, height: 70))
        whiteRoundedView.layer.backgroundColor = pinkColor.cgColor
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 10.0
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        popUpContent = answers[indexPath.row]
        popUpTitle = questions[indexPath.row]
        performSegue(withIdentifier: "PopUp", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "PopUp") {
            let popUpVC = segue.destination as! FAQpopupViewController
            popUpVC.titleLbl = self.popUpTitle
            popUpVC.contentLbl = self.popUpContent
        }
    }
}
