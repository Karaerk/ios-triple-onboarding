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
    
    @IBOutlet private var answerBtns: [UIButton]!
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var questionNumberLabel: UILabel!
    @IBOutlet weak private var scoreLabel: UILabel!
    
    private var ref: DatabaseReference!
    
    private var questionCounter: Int = 0
    private var quesionText: String!
    
    private let defaults = UserDefaults.standard
    
    //variables for the score and round
    private var score = 0
    private var questionNumber = 1
    
    private var highscoreQuiz = UserDefaults.standard.integer(forKey: "HighScoreQuizKey")
    
    private let pinkColor = UIColor(red: 236/255, green: 102/255, blue: 118/255, alpha: 1)
    
    private let haptic = UINotificationFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateContent()
        updateLabels()
    }
    
    //function for the quiz to get info from the database and show it
    func updateContent(){
        resetUI()
        //Database for Question title
        ref = Database.database().reference()
        let questions = Database.database().reference().child("quiz")
        let singleQuestion = questions.child("\(questionCounter)")
        let answers = singleQuestion.child("answer")
        
        //returns the end game popup after the last quistion is answered
        singleQuestion.observeSingleEvent(of: .value) { (snapshot) in
            guard let firebaseResponse = snapshot.value as? [String:Any] else{
                return self.performSegue(withIdentifier: "QuizEndPopUp", sender: self)
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
        //Color and layout buttons
        for buttons in answerBtns{
            buttons.layer.cornerRadius = 40
            buttons.backgroundColor = pinkColor
        }
        //random answer buttons
        answerBtns.shuffle()
    }
    //Reset function for every new question
    func resetUI(){
        for i in 0..<answerBtns.count{
            answerBtns[i].setTitle("", for: .normal)
            answerBtns[i].backgroundColor = UIColor.clear
        }
    }
    
    //function for the answer buttons
    @IBAction func answerBtn(_ sender: UIButton) {
        //when the tag is 1 the answer = correct, tag 0 = incorrect
        if sender.tag == 1 {
            haptic.notificationOccurred(.success)
            sender.backgroundColor = UIColor.green
            questionCounter += 1
            questionNumber += 1
            onRightAnswer()
        } else {
            sender.backgroundColor = UIColor.red
            haptic.notificationOccurred(.error)
            onWrongAnswer()
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
         if (score > highscoreQuiz){
             highscoreQuiz = score
             defaults.set(highscoreQuiz, forKey: "HighScoreQuizKey")
         }
     }
    
    //function to set the segue towards the gamepopupviewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "QuizEndPopUp") {
            let gamePopUpVC = segue.destination as! GamePopUpViewController
            gamePopUpVC.scoreLbl = String("Je score: \(score)")
            gamePopUpVC.highScoreLbl = String("Highscore: \(highscoreQuiz)")
        }
    }
    
}
