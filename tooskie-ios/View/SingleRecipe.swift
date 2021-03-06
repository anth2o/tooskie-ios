//
//  SingleRecipe.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 07/10/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class SingleRecipe: UIView {
    
    private var recipe: Recipe?


    @IBOutlet public var label: UILabel!
    @IBOutlet private var icon: UIImageView!
    @IBOutlet weak var preparationTime: UILabel!
    @IBOutlet weak var cookingTime: UILabel!
    @IBOutlet weak var numberOfSteps: UILabel!
    @IBOutlet weak var difficultyLevel: UILabel!
    @IBOutlet weak var budgetLevel: UILabel!
    
    enum Status {
        case accepted, declined, waiting
    }
    
    var status: Status = .waiting
    
    private func clear() {
        self.label.text = nil
        self.icon.image = nil
        self.preparationTime.text = nil
        self.cookingTime.text = nil
        self.numberOfSteps.text = nil
        self.difficultyLevel.text = nil
        self.budgetLevel.text = nil
    }

    public func setRecipe(recipe: Recipe) {
        self.setBorder(borderWidth: 3.0)
        self.clear()
        self.recipe = recipe
        self.label.text = recipe.name
        if let pictureData = recipe.getPictureData() {
            self.icon.image = UIImage(data: pictureData)
        }
        else {
            self.icon.image = UIImage(named: "NoNetwork")
        }
        if let preparationTime = recipe.preparationTime{
            self.preparationTime.text = String(preparationTime) + " min"
        }
        if let cookingTime = recipe.cookingTime{
            self.cookingTime.text = String(cookingTime) + " min"
        }
        if let numberOfSteps = recipe.numberOfSteps{
            self.numberOfSteps.text = String(numberOfSteps) + " étapes"
        }
        if let difficultyLevel = recipe.difficultyLevel{
            self.difficultyLevel.text = difficultyLevel
        }
        if let budgetLevel = recipe.budgetLevel{
            self.budgetLevel.text = budgetLevel
        }
    }
}
