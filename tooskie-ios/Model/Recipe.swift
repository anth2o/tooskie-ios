//
//  Recipe.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 05/10/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import Foundation

class Recipe: Codable {
    public var name: String
    public var picture: String?
    public var pictureData: Data?
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
    
    public func getPictureData() -> Data?{
        if self.pictureData != nil {
            return self.pictureData
        }
        if let picture = self.picture {
            if let url = URL(string: picture) {
                let data = try? Data(contentsOf: url)
                if let data = data {
                    self.pictureData = data
                    return data
                }
            }
        }
        return nil
    }
}
