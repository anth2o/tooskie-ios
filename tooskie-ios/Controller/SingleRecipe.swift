//
//  SingleRecipe.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 07/10/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class SingleRecipe: UIView {

    @IBOutlet public var label: UILabel!
    @IBOutlet private var icon: UIImageView!
    private var recipe: Recipe?
    @IBOutlet weak var preparationTime: UILabel!
    @IBOutlet weak var cookingTime: UILabel!
    @IBOutlet weak var numberOfSteps: UILabel!
    
    public func setRecipe(recipe: Recipe) {
        self.recipe = recipe
        self.label.text = recipe.name
        if let pictureString = recipe.picture{
            let url = URL(string: pictureString)
            let data = try? Data(contentsOf: url!)
            if let data = data {
                self.icon.image = UIImage(data: data)
            }
        }
        if let preparationTime = recipe.preparationTime{
            self.preparationTime.text = String(preparationTime) + " min"
        }
    }
}
