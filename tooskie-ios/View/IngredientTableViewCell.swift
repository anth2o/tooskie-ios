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
    var viewController: SearchTableViewController?
    
    @IBOutlet weak var ingredientName: UILabel!
    @IBOutlet weak var ingredientPicture: UIImageView!
    @IBAction func discardIngredient(_ sender: Any) {
        if self.viewController != nil && self.ingredient != nil {
            self.viewController!.removeIngredient(ingredient: self.ingredient!)
        }
    }
}
