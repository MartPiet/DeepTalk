//
//  DataManager.swift
//  DeepTalk
//
//  Created by Martin Pietrowski on 24.01.18.
//  Copyright © 2018 devpie. All rights reserved.
//

import Foundation

// TODO: Schöner machen, debuggen: es lassen sich die Fragen nicht nach Kategorie filtern.

class DataManager {
    private var questions: [String]!
    private let categoriesResource = "Categories"
    private let questionsResource = "Questions"
    
    private var selectedCategories: [String]! {
        didSet {
            if oldValue == nil || (oldValue != nil && oldValue != selectedCategories) {
                questions = fetchQuestions(categories: selectedCategories)
                print(selectedCategories ?? "None")
            }
        }
    }
    
    init() {
        initSelectedCategories()
    }
    
    // Needed so observer can detect change. (Does not work when method content runs in init())
    private func initSelectedCategories() {
        self.selectedCategories = fetchCategories(all: false)
    }
    
    private func fetchQuestions(categories: [String]?) -> [String] {
        guard let jsonResult = fetchJSON(forResource: questionsResource) as? Dictionary<String, [String]> else {
            return [String]()
        }
        
        let tmpCategories = categories ?? Array(jsonResult.keys)
        
        var tmpQuestions = [String]()
        
        for key in tmpCategories {
            if jsonResult[key] != nil { tmpQuestions.append(contentsOf: jsonResult[key]!) }
        }
        
        questions = tmpQuestions.shuffled()
        
        return questions
    }
    
    private func fetchCategories(all: Bool) -> [String] {
        guard let jsonResult = fetchJSON(forResource: categoriesResource) as? Dictionary<String, Bool> else {
            return [String]()
        }

        let tmpAllCategories = Array(jsonResult.keys)
        let tmpSelectedCategory = jsonResult.allKeys(forValue: true)

        return all ? tmpAllCategories : tmpSelectedCategory
    }
    
    private func fetchJSON(forResource resource: String) -> Dictionary<String, Any>? {
        if let path = Bundle.main.path(forResource: resource, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, Any> {
                    return jsonResult
                }
            } catch {
                fatalError("JSON file \"\(resource).json\" not readable.")
            }
        }
        return nil
    }
    
    private func saveJSON(content: Dictionary<String, Bool>, filename: String) {
        if let encodedData = try? JSONEncoder().encode(content) {
            guard let path = Bundle.main.path(forResource: filename, ofType: "json") else {
                fatalError("Missing file \"\(filename)\"")
            }
            let pathAsURL = URL(fileURLWithPath: path)
            do {
                try encodedData.write(to: pathAsURL)
            }
            catch {
                print("Failed to write JSON data: \(error.localizedDescription)")
            }
        }
    }
    
    func getCategories(all: Bool) -> [String] {
        return fetchCategories(all: all)
    }
    
    func switchCategory(categoryName category: String) {
        guard var allCategoriesDict = fetchJSON(forResource: categoriesResource) as? Dictionary<String, Bool> else {
            fatalError("Categories.json loading failed.")
        }
        
        guard let isCategoryEnabled = allCategoriesDict[category] else {
            //          TODO: Try the line below out
            //            throw SerializationError.missing(category)
            fatalError("Missing value for key \"\(category)\".")
        }
        
        allCategoriesDict[category] = !isCategoryEnabled
        
        saveJSON(content: allCategoriesDict, filename: "Categories")
        
        selectedCategories = fetchCategories(all: false)
    }
    
    
    func getQuestions(categories: [String]?) -> [String] {
        return questions ?? fetchQuestions(categories: categories)
    }
    
    func getQuestion(atIndex index: Int) -> String? {
        if let questions = questions, index < questions.count - 1 {
            return questions[index]
        }
        
        return nil
    }
    
    func shuffleQuestions() -> [String] {
        selectedCategories = fetchCategories(all: false)
        questions = questions.shuffled()
        
        return questions
    }
}
