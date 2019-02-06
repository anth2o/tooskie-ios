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
    
    init(name: String){
        self.name = name
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
    
    private func getIngredientsToString() -> [String] {
        var ingredientsString = [String]()
        if let ingredients = self.ingredients {
            for i in 0..<ingredients.count {
                ingredientsString.append(ingredients[i].getName())
            }
        }
        return ingredientsString
    }
    
    private func getStepsToString() -> [String] {
        var stepsString = [String]()
        if let steps = self.steps {
            for i in 0..<steps.count {
                if let description = steps[i].description {
                    stepsString.append(description)
                }
            }
        }
        return stepsString
    }
    
    public func toPost(userName: String?, isAccepted: Bool, time: String?) -> PostRecipe {
        return PostRecipe(
            recipeName: self.name,
            ingredients: self.getIngredientsToString(),
            user: userName,
            picture: picture,
            cookingTime: cookingTime,
            preparationTime: preparationTime,
            budgetLevel: budgetLevel,
            difficultyLevel: difficultyLevel,
            tags: tags,
            steps: getStepsToString(),
            ustensils: ustensils,
            isAccepted: isAccepted,
            timestampSent: time)
    }
}

struct PostRecipe: Codable {
    let recipeName: String
    let ingredients: [String]
    let user: String?
    let picture: String?
    let cookingTime: Int?
    let preparationTime: Int?
    let budgetLevel: String?
    let difficultyLevel: String?
    let tags: [String]?
    let steps: [String]?
    let ustensils: [String]?
    let isAccepted: Bool
    let timestampSent: String?
}
