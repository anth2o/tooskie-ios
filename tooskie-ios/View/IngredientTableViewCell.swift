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
    var viewController: PantryFillViewController?
    
    @IBOutlet weak var ingredientName: UILabel!
    @IBOutlet weak var ingredientPicture: UIImageView!
    @IBAction func discardIngredient(_ sender: Any) {
        if self.viewController != nil && self.ingredient != nil {
            self.viewController!.removeIngredient(ingredient: self.ingredient!)
        }
    }
    
    func setIngredient(ingredient: Ingredient, viewController: PantryFillViewController) {
        self.ingredient = ingredient
        self.viewController = viewController
        self.ingredientName.text = ingredient.getName()
        if let pictureString = ingredient.getPictureString() {
            let url = URL(string: pictureString)
            if url != nil {
                let data = try? Data(contentsOf: url!)
                if let data = data {
                    self.ingredientPicture.image = UIImage(data: data)
                }
                else {
                    self.ingredientPicture.image = UIImage(named: "NoNetwork")
                }
            }
            else {
                self.ingredientPicture.image = UIImage(named: "NoNetwork")
            }
        }
    }
}
