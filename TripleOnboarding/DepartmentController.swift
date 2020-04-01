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

struct departmentContent{
    var thumbnail : UIImage!
    var image : UIImage!
    var title : String
    var content : String
}

class DepartmentController: UITableViewController {
    
    var ref: DatabaseReference!
    
    //Used for the popup controller
    var departPageTitle: String!
    var departPageContent: String!
    var departPageImage: UIImage!
    
    var departContents = [departmentContent]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
            
            //Thumbnail
            let thumbnailData = try! Data(contentsOf: thumbnailUrl!)
            let thumbnail = UIImage(data: thumbnailData)
            //Image
            let imageData = try! Data(contentsOf: imageUrl!)
            let image = UIImage(data: imageData)
            
            //Append the title and content from firebase to the struct
            self.departContents.append(departmentContent(thumbnail: thumbnail, image: image, title: departTitle, content: departContent))
            self.tableView.reloadData()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return departContents.count     //Size of the struct
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Uses the variables from departmentcell
        let cell = tableView.dequeueReusableCell(withIdentifier: "DepartmentCell", for: indexPath) as! DepartmentCell
        let content = departContents[indexPath.row]
        cell.departTitle.text = content.title
        cell.departImage.image = content.thumbnail
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = departContents[indexPath.row]
        //Is used to show the correct labels at the pop up controller
        departPageTitle = content.title
        departPageContent = content.content
        departPageImage = content.image
        performSegue(withIdentifier: "DepartmentPage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "DepartmentPage") {
            let departVC = segue.destination as! DepartmentPopUpController
            departVC.titleLbl = self.departPageTitle
            departVC.contentLbl = self.departPageContent
            departVC.imageView = self.departPageImage
        }
    }
}

