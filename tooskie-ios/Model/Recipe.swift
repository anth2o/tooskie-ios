//
//  Recipe.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 05/10/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import Foundation

class Recipe: Codable{
    public var name: String
    public var picture: String?
    var cookingTime: Int?
    var preparationTime: Int?
    var budgetLevel: String?
    var difficultyLevel: String?
    var tag: [String]?
    var steps: [String]?
    private var _numberOfSteps: Int?
    var numberOfSteps: Int?
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
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, numberOfSteps: Int) {
        self.name = name
        self.numberOfSteps = numberOfSteps
    }
    
    convenience init() {
        self.init(name: "Poulet au fromage")
    }
}
