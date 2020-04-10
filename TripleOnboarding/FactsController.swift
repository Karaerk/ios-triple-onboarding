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
        
        //Is used for the lay-out from the tableview
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
        let content = factsCont[indexPath.row]
        popUpContent = content.content
        popUpTitle = content.categorie
        performSegue(withIdentifier: "PopUp", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "PopUp") {
            let popUpVC = segue.destination as! FactsPopUpController
            popUpVC.titleLbl = self.popUpTitle
            popUpVC.contentLbl = self.popUpContent
        }
    }
}
