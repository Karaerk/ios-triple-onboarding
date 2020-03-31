//
//  MemoryViewController.swift
//  TripleOnboarding
//
//  Created by Costa van Elsas on 18/03/2020.
//  Copyright © 2020 Triple. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class MemoryViewController: UIViewController {

    @IBOutlet var answerBtns: [UIButton]!
    
    @IBOutlet weak var employeePhoto: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionNumberLabel: UILabel!
    
    var ref: DatabaseReference!
    var counter: Int = 0
    var score = 0
    var questionNumber = 1
    
    let haptic = UINotificationFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateMemory()
    }
    
    func updateMemory(){
        resetUI()

        ref = Database.database().reference()
        let empoloyeePhotos = Database.database().reference().child("memory")
        let empoloyeePhoto = empoloyeePhotos.child("\(counter)")
        let answers = empoloyeePhoto.child("answer")
       
        empoloyeePhoto.observeSingleEvent(of: .value) { (snapshot) in
            guard let firebaseResponse = snapshot.value as? [String:Any] else{
                return
            }
            self.employeePhoto.text = (firebaseResponse["image"]) as? String
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
        
        for buttons in answerBtns {
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
                counter += 1
                score += 1
                questionNumber += 1
                updateMemory()
            } else {
                sender.backgroundColor = UIColor.red
                haptic.notificationOccurred(.error)
            }
        }
    }

