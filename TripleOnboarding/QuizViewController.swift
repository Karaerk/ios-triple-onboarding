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
    
    let haptic = UINotificationFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateQuiz()
    }
    
    func updateQuiz(){
        resetUI()
        //Database for Question title
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
        
        //For question answer
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
        
        for buttons in answerBtns{
            buttons.layer.cornerRadius = 40
            buttons.backgroundColor = UIColor(red: 236/255, green: 102/255, blue: 118/255, alpha: 1)
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
                questionCounter += 1
                updateQuiz()
                
            } else {
                sender.backgroundColor = UIColor.red
                haptic.notificationOccurred(.error)
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
