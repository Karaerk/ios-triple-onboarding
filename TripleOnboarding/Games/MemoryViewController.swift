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

    @IBOutlet private var answerBtns: [UIButton]!
    
    //@IBOutlet weak var employeePhoto: UILabel!
    @IBOutlet weak private var scoreLabel: UILabel!
    @IBOutlet weak private var questionNumberLabel: UILabel!
    @IBOutlet weak private var employeePhotoUI: UIImageView!
    private var image : UIImage!
    
    private var ref: DatabaseReference!
    private var counter: Int = 0
    
    private let defaults = UserDefaults.standard
    
    //variables for the score and round
    private var score = 0
    private var questionNumber = 1
    private var highscoreMemory = UserDefaults.standard.integer(forKey: "HighScoreMemoryKey")
    
    private let haptic = UINotificationFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateContent()
        updateLabels()
    }
    
    //function for the memory to get info from the database and show it
    func updateContent(){
        resetUI()

        //database for the memory
        ref = Database.database().reference()
        let empoloyeePhotos = Database.database().reference().child("memory")
        let empoloyeePhoto = empoloyeePhotos.child("\(counter)")
        let answers = empoloyeePhoto.child("answer")

        //returns the end game popup after the last quistion is answered
        empoloyeePhoto.observeSingleEvent(of: .value) { (snapshot) in
            guard let firebaseResponse = snapshot.value as? [String:Any] else{
                return self.performSegue(withIdentifier: "EndGamePopUp", sender: self)
            }
        
            //get the image from the db
            let imageUrl = URL(string: (firebaseResponse["image"] as? String)!)
            let imageData = try! Data(contentsOf: imageUrl!)
            self.employeePhotoUI.image = UIImage(data: imageData)
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
            buttons.layer.cornerRadius = 20
            buttons.backgroundColor = UIColor(red: 236/255, green: 102/255, blue: 118/255, alpha: 1)
        }
        // random answer buttons
        answerBtns.shuffle()
    }
    
    //function for the answer buttons
    @IBAction func answerButtons(_ sender: UIButton) {
        //when the tag is 1 the answer = correct, tag 0 = incorrect
        if sender.tag == 1 {
            haptic.notificationOccurred(.success)
            sender.backgroundColor = UIColor.green
            counter += 1
            questionNumber += 1
            onRightAnswer()
        } else if sender.tag == 0{
            sender.backgroundColor = UIColor.red
            haptic.notificationOccurred(.error)
            onWrongAnswer()
        }
    }
    
    //Reset function for every new question
    func resetUI(){
        for i in 0..<answerBtns.count{
            answerBtns[i].setTitle("", for: .normal)
            answerBtns[i].backgroundColor = UIColor.clear
        }
    }
    
    //function to update the score and questionnmb labels
    func updateLabels(){
        scoreLabel.text = String(score)
        questionNumberLabel.text = String(questionNumber)
    }
    
    //function score when its incorrect
    func onWrongAnswer(){
        score -= 1
    }
    
    //function score when its correct
    func onRightAnswer(){
        score += 10
        updateLabels()
        updateContent()
        updateHighScore()
    }
    
    func updateHighScore(){
        if (score > highscoreMemory){
            highscoreMemory = score
            defaults.set(highscoreMemory, forKey: "HighScoreMemoryKey")
        }
    }
    
    //function to set the segue towards the gamepopupviewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if (segue.identifier == "EndGamePopUp") {
         let gamePopUpVC = segue.destination as! GamePopUpViewController
        
        gamePopUpVC.scoreLbl = String("Je score: \(score)")
        gamePopUpVC.highScoreLbl = String("Highscore: \(highscoreMemory)")
     }
    }
}
