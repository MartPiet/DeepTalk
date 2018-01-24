//
//  DeepTalkViewController.swift
//  DeepTalk
//
//  Created by Martin Pietrowski on 19.01.18.
//  Copyright © 2018 devpie. All rights reserved.
//

import UIKit

class DeepTalkViewController: UIViewController {
    @IBOutlet weak var questionsTextView: UITextView!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var newRoundButton: UIButton!
    
    var dataManager: DataManager!
    var questions: [String]!
    var questionsCounter: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataManager = DataManager()
        questions = dataManager.getQuestions(categories: dataManager.getCategories(all: false))
        
        questionsCounter = 0
        nextQuestion()
    }
    
    @IBAction func nextQuestionButtonAction(_ sender: Any) {
        nextQuestion()
    }
    
    private func nextQuestion() {
        if let question = dataManager.getQuestion(atIndex: questionsCounter) {
            questionsCounter = questionsCounter + 1
            setQuestionTextView(text: question)
        } else {
            // TODO: AlertView to shuffle questions and show them again
            setQuestionTextView(text: "Keine Fragen mehr vorhanden.")
        }
    }
    
    @IBAction func newRound(_ sender: UIButton) {
        questions = dataManager.shuffleQuestions()
        questionsCounter = 0
        
        if let question = dataManager.getQuestion(atIndex: 0) {
            setQuestionTextView(text: question)
        } else {
            setQuestionTextView(text: "Keine Fragen vorhanden.")
        }
    }
    
    private func setQuestionTextView(text: String) {
        questionTextView.text = text
    }

}
