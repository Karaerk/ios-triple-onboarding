//
//  QuizViewController.swift
//  TripleOnboarding
//
//  Created by Youri Berentsen on 10/03/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class QuizViewController: UIViewController {
    
    @IBOutlet var answerBtns: [UIButton]!
    @IBOutlet weak var questionLabel: UILabel!
    
    var ref: DatabaseReference!
    var myref: DatabaseReference!
    
    var questionCounter: Int = 0
    
    var quesionText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateQuiz()
        
    }
    
    func updateQuiz(){
        ref = Database.database().reference()
        
        let questions = Database.database().reference().child("quiz")
        let singleQuestion = questions.child("\(questionCounter)")
        let answers = singleQuestion.child("answer")
        
        singleQuestion.observeSingleEvent(of: .value) { (snapshot) in
            guard let firebaseResponse = snapshot.value as? [String:Any] else{
                return
            }
            self.questionLabel.text = (firebaseResponse["question"]) as? String
        }
        
        for i in 0..<answerBtns.count {
            answers.child("\(i)").queryOrdered(byChild: "content").observeSingleEvent(of: .value) { (snap) in
                guard let content = snap.value as? [String:Any] else{
                    return
                }
                self.answerBtns[i].setTitle(content["content"] as? String, for: .normal)
                let isCorrect = content["is_correct"] as! NSInteger
                self.answerBtns[i].tag = isCorrect
            }
        }
    }

    @IBAction func answerBtn(_ sender: UIButton) {
        if sender.tag == 1 {
            questionCounter += 1
            updateQuiz()
            print(questionCounter)
        } else {
            print("incorrect")
        }
    }
}





//            ref.child("quiz").child("\(questionCounter)").observeSingleEvent(of: .value) { (snapshot) in
//                guard let firebaseResponse = snapshot.value as? [String:Any] else{
//                    return
//                }
//                self.questionLabel.text = (firebaseResponse["question"]) as? String
//                let arrayQuestion = firebaseResponse["answer"] as Any
//                print(firebaseResponse["answers"] as Any)
//
//                //print(arrayQuestion["content"])
//
//
//    //            for i in 0..<arrayQuestion.count {
//    //                self.answerBtns[i].setTitle(arrayQuestion[i] as? String, for: .normal)
//    //            }
//            }
//    }
