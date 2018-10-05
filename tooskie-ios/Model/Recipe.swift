//
//  Recipe.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 05/10/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import Foundation

class Recipe: Codable{
    var name: String
    var picture: String?
    var cooking_time: Int?
    var preparation_time: Int?
    var budget_level: String?
    var difficulty_level: String?
    var tag: [String]?
    var steps: [String]?
    private var _numberOfSteps: Int?
    var number_of_steps: Int?
    {
        get {
            if let trueSteps = steps {
                return trueSteps.count
            }
            else if let trueNumberOfSteps = _numberOfSteps {
                return trueNumberOfSteps
            }
            return nil
        }
        set {
            if steps == nil {
                _numberOfSteps = newValue
            }
        }
    }

//    enum CodingKeys: String {
//        case name = "name"
//        case picture = "picture"
//        case cookingTime = "cooking_time"
//        case preparationTime = "preparation_time"
//        case budgetLevel = "budget_level"
//        case difficultyLevel = "difficulty_level"
//        case tag = "tag"
//        case numberOfSteps = "number_of_steps"
//    }
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, numberOfSteps: Int) {
        self.name = name
        self.number_of_steps = numberOfSteps
    }
    
    convenience init() {
        self.init(name: "Poulet au fromage")
    }
}
