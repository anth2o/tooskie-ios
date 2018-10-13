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
    var tags: [String]?
    var steps: [Step]?
    var ustensils: [String]?
    var ingredients: [Ingredient]?
    var numberOfSteps: Int?
    {
        if let trueSteps = steps {
            return trueSteps.count
        }
        return nil
    }
    
    init(name: String) {
        self.name = name
    }
    
    convenience init() {
        self.init(name: "Poulet au fromage")
    }
    
    func getStep(stepNumber: Int) -> Step?{
        if let steps = self.steps {
            for i in 0..<steps.count {
                if let number = steps[i].stepNumber {
                    if number == stepNumber {
                        return steps[i]
                    }
                }
            }
        }
        return nil
    }
}
