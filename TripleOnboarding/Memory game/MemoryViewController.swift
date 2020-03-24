//
//  MemoryViewController.swift
//  TripleOnboarding
//
//  Created by hva_1 on 18/03/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class MemoryViewController: UIViewController {

    @IBOutlet var answerBtns: [UIButton]!
    @IBOutlet weak var imageView: UIImageView!
    
    var ref: DatabaseReference!
    var counter: Int = 0
    var quesionText: String!
    
    // Initialize an array for pictures
    var picArray: [UIImage]!
    
    let haptic = UINotificationFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateMemory()
    }
    
    func updateMemory(){
        resetUI()

        ref = Database.database().reference()
        let questions = Database.database().reference().child("memory")
        let singleQuestion = questions.child("\(counter)")
        let answers = singleQuestion.child("answer")
       
        singleQuestion.observeSingleEvent(of: .value) { (snapshot) in
            guard let firebaseResponse = snapshot.value as? [String:Any] else{
                return
            }
            self.imageView.image = (firebaseResponse["image"]) as? UIImage
        }
        
        for i in 0..<answerBtns.count {
            answers.child("\(i)").observeSingleEvent(of: .value) { (snap) in
                guard let content = snap.value as? [String:Any] else{
                    return
                }
                self.answerBtns[i].setTitle(content["content"] as? String, for: .normal)
                let isCorrect = content["correct"] as! NSInteger
                self.answerBtns[i].tag = isCorrect
            }
        }
        answerBtns.shuffle()
    }
    
    func resetUI(){
        for i in 0..<answerBtns.count{
            answerBtns[i].setTitle("", for: .normal)
            answerBtns[i].backgroundColor = UIColor.clear
        }
    }
        
        @IBAction func answerBtn(_ sender: UIButton) {
            if sender.tag == 1 {
                haptic.notificationOccurred(.success)
                sender.backgroundColor = UIColor.green
                counter += 1
                updateMemory()
                
            } else {
                sender.backgroundColor = UIColor.red
                haptic.notificationOccurred(.error)
            }
        }
    }

