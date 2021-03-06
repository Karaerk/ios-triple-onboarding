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

class FAQController: UITableViewController {
    
    private var ref: DatabaseReference!
    
    private var questions : [String] = []
    private var answers : [String] = []
    
    private var popUpTitle: String!
    private var popUpContent: String!
    
    private var rowHeight : CGFloat = 75
    private var fontSize : CGFloat = 25
    
    private let pinkColor = UIColor(red: 236/255, green: 102/255, blue: 118/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        updateContent()
    }
    
    func updateContent(){
        ref = Database.database().reference().child("faq")
        
        ref.queryOrdered(byChild: "question").observe(.childAdded) { (snapshot) in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! ButtonsCell
        cell.updateContent(text: questions[indexPath.row])

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
            let popUpVC = segue.destination as! PopUpController
            popUpVC.titleLbl = self.popUpTitle
            popUpVC.contentLbl = self.popUpContent
        }
    }
}
