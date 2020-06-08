//
//  DepartmentController.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 24/03/2020.
//  Copyright © 2020 Triple. All rights reserved.
//
import Foundation
import UIKit
import FirebaseDatabase
import Nuke

struct DepartmentContent{
    var thumbnail : URL!
    var image : URL!
    var title : String
    var content : String
}

class DepartmentController: UITableViewController {
    
    private var ref: DatabaseReference!
    
    //Used for the popup controller
    private var departPageTitle: String!
    private var departPageContent: String!
    private var departPageImage: URL!
    
    private var sequeIdentifier = "DepartmentPage"
    
    private var departContents = [DepartmentContent]()
    override func viewDidLoad() {
        super.viewDidLoad()

        updateContent()
    }
    
    func updateContent(){
        ref = Database.database().reference().child("department")
        
        ref.observe(.childAdded) { (snapshot) in
            guard let firebaseResponse = snapshot.value as? [String:Any] else{
                return
            }
            let departTitle = (firebaseResponse["title"] as? String)!
            let departContent = (firebaseResponse["content"] as? String)!
            
            let thumbnailUrl = URL(string: (firebaseResponse["thumbnail"] as? String)!)
            let imageUrl = URL(string: (firebaseResponse["image"] as? String)!)
            
            //Append the title and content from firebase to the struct
            self.departContents.append(DepartmentContent(thumbnail: thumbnailUrl, image: imageUrl, title: departTitle, content: departContent))
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return departContents.count     //Size of the struct
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Uses the variables from departmentcell
        let cell = tableView.dequeueReusableCell(withIdentifier: "DepartmentCell", for: indexPath) as! ImageTitleCell
        let content = departContents[indexPath.row]
        //Image processing
        let options = ImageLoadingOptions(
            placeholder: #imageLiteral(resourceName: "Triple Logo"),
            transition: .fadeIn(duration: 0.33)
        )
        cell.titleLabel.text = content.title
        Nuke.loadImage(with: content.thumbnail, options: options, into: cell.imageViewUI)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = departContents[indexPath.row]
        //Is used to show the correct labels at the pop up controller
        departPageTitle = content.title
        departPageContent = content.content
        departPageImage = content.image
        performSegue(withIdentifier: sequeIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == sequeIdentifier) {
            let departVC = segue.destination as! DepartmentPopUpController
            departVC.titleLbl = self.departPageTitle
            departVC.contentLbl = self.departPageContent
            departVC.imageView = self.departPageImage
        }
    }
}

