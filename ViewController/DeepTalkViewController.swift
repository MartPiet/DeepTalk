//
//  DeepTalkViewController.swift
//  DeepTalk
//
//  Created by Martin Pietrowski on 19.01.18.
//  Copyright © 2018 devpie. All rights reserved.
//

import UIKit

class DeepTalkViewController: UIViewController {
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var newRoundButton: UIButton!
    
    lazy var dataManager = DataManager()
    lazy var questions = dataManager.getQuestions(categories: dataManager.getCategories(all: false))
    lazy var questionsCounter = 0
    
    var currentQuestion: String = "" {
        didSet {
            questionTextView.text = currentQuestion
            questionsCounter = questionsCounter + 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Kefa", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0), NSAttributedStringKey.foregroundColor : UIColor.white]
        
        nextQuestion()
    }
    
    @IBAction func nextQuestionButtonAction(_ sender: Any) {
        nextQuestion()
    }
    
    @IBAction func newRound(_ sender: UIButton) {
        print("test")
        questions = dataManager.shuffleQuestions()
        questionsCounter = 0
        
        nextQuestion()
    }
    
    private func nextQuestion() {
        currentQuestion = dataManager.getQuestion(atIndex: questionsCounter) ?? "Keine Fragen vorhanden."
    }
}
