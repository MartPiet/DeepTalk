//
//  DataManager.swift
//  DeepTalk
//
//  Created by Martin Pietrowski on 24.01.18.
//  Copyright © 2018 devpie. All rights reserved.
//

import Foundation

class DataManager {
    private var questions: [String]?
    private var allCategories: [String]?
    private var selectedCategories: [String]?
    private var lock: Bool!
    
    init() {
        lock = false
        _ = fetchCategories(all: false)
        _ = fetchQuestions(categories: selectedCategories)
    }
    
    private func fetchQuestions(categories: [String]?) -> [String] {
        guard let jsonResult = fetchQuestionsJSON() else {
            return [String]()
        }
        
        var tmpCategories = [String]()
        
        if let categories = categories {
            tmpCategories = categories
        } else {
            tmpCategories = Array(jsonResult.keys)
        }
       
        var tmpQuestions = [String]()
        for key in tmpCategories {
            guard let groupedQuestions = jsonResult[key] else {
                fatalError("Key not fetchable in in dictionary.")
            }
            tmpQuestions = tmpQuestions + groupedQuestions
        }
        
        tmpQuestions = tmpQuestions.shuffled()
        
        questions = tmpQuestions
        
        return tmpQuestions
    }
    
    private func fetchCategories(all: Bool) -> [String] {
        guard let jsonResult = fetchCategoriesJSON() else {
            return [String]()
        }
        
        allCategories = Array(jsonResult.keys)
        selectedCategories = jsonResult.allKeys(forValue: true)
        
        guard let tmpAllCategories = allCategories else {
            fatalError("No categories fetched.")
        }
        
        guard let tmpSelectedCategory = selectedCategories else {
            print("No categories selected.")
            return [String]()
        }

        if all {
            return tmpAllCategories
        } else {
            return tmpSelectedCategory
        }
        
    }
    
    private func fetchQuestionsJSON() -> Dictionary<String, [String]>? {
        if let path = Bundle.main.path(forResource: "Questions", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, [String]> {
                    return jsonResult
                }
            } catch {
                fatalError("JSON file \"Questions.json\" not readable.")
            }
        }
        return nil
    }
    
    private func fetchCategoriesJSON() -> Dictionary<String, Bool>? {
        if let path = Bundle.main.path(forResource: "Categories", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, Bool> {
                    return jsonResult
                }
            } catch {
                fatalError("JSON file not readable.")
            }
        }
        return nil
    }
    
    func getCategories(all: Bool) -> [String] {
        return fetchCategories(all: all)
    }
    
    func switchCategory(categoryName category: String) {
        guard var allCategoriesDict = fetchCategoriesJSON() else {
            fatalError("Categories.json loading failed.")
        }
        
        guard let isCategoryEnabled = allCategoriesDict[category] else {
            //          TODO: Try the line below out
            //            throw SerializationError.missing(category)
            fatalError("Missing value for key \"\(category)\".")
        }
        
        allCategoriesDict[category] = !isCategoryEnabled
        
        //TODO: Write Dictionary into JSON.
    }
    
    func getQuestions(categories: [String]?) -> [String] {
        if let questions = questions {
            return questions
        } else {
            return fetchQuestions(categories: categories)
        }
    }
    
    func getQuestion(atIndex index: Int) -> String? {
        if let questions = questions {
            if index < questions.count - 1 {
                return questions[index]
            }
        }
        return nil
    }
    
    func shuffleQuestions() -> [String] {
        if var questions = questions {
            lock = false
            questions = questions.shuffled()
            self.questions = questions
            
            return questions
        } else if !lock {
            lock = true
            _ = fetchQuestions(categories: selectedCategories)
            
            return shuffleQuestions()
        } else {
            fatalError("Prevented endless loop.")
        }
    }
}
