//
//  Pantry.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 29/09/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class PantryTableView: UITableView {
    
    var pantry: Pantry?
    var ingredientCells = [String: IngredientTableViewCell]()
    var lastIndex = 0
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func addIngredient(ingredient: Ingredient) {
        if self.pantry != nil {
            let ingredientAdded = self.pantry!.addIngredient(ingredient: ingredient)
            if ingredientAdded != nil {
                self.ingredientCells[ingredientAdded!.name] = IngredientTableViewCell(ingredient: ingredientAdded!)
            }
        }
    }
}
