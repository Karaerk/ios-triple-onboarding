//
//  FactsController.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 17/03/2020.
//  Copyright © 2020 Triple. All rights reserved.
//
import Foundation
import UIKit
import FirebaseDatabase

struct FactsContent{
    var categorie: String!
    var content: String!
}

class FactsController: UITableViewController {
    
    private var ref: DatabaseReference!
    private var factsCont = [FactsContent]()
    //Used for the pop up controller
    private var popUpTitle: String!
    private var popUpContent: String!
    
    private var rowHeight : CGFloat = 75
    private var fontSize : CGFloat = 25
    
    private let pinkColor = UIColor(red: 236/255, green: 102/255, blue: 118/255, alpha: 1)
    
    private enum SegueIdentifier: String{
    case PopUp
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        updateContent()
    }
    
    func updateContent(){
        
        ref = Database.database().reference().child("facts")
        ref.queryOrdered(byChild: "title").observe(.childAdded) { (snapshot) in
            guard let firebaseResponse = snapshot.value as? [String:Any] else{
                return
            }
            //Append the content and categorie to the struct
            let categorieTitle = (firebaseResponse["title"] as? String)!
            let contentText = (firebaseResponse["content"] as? String)!
            self.factsCont.append(FactsContent(categorie: categorieTitle, content: contentText))

            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return factsCont.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategorieCell", for: indexPath)
        let content = factsCont[indexPath.row]
        cell.textLabel?.text = content.categorie
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont(name: "Dosis-Regular", size: fontSize)
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = pinkColor
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 5
        cell.layer.cornerRadius = 20

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = factsCont[indexPath.row]
        popUpContent = content.content
        popUpTitle = content.categorie
        performSegue(withIdentifier: SegueIdentifier.PopUp.rawValue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, let SegueIdentifier = SegueIdentifier(rawValue: identifier) {
            switch SegueIdentifier {
            case .PopUp:
                let popUpVC = segue.destination as! PopUpController
                popUpVC.titleLbl = self.popUpTitle
                popUpVC.contentLbl = self.popUpContent
            }
        }
    }
}
