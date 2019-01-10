//
//  IngredientTableViewCell.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 29/09/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {
    var ingredient: Ingredient?
    
    @IBOutlet weak var ingredientName: UILabel!
    @IBOutlet weak var ingredientPicture: UIImageView?
    @IBAction func discardIngredient(_ sender: Any) {
        if let ingredient = self.ingredient {
            NotificationCenter.default.post(name: .removeIngredient, object: self, userInfo: ["ingredient": ingredient])
        }
    }
}
