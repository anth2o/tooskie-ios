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
    var ingredients = [String: IngredientTableViewCell]()
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
//            if ingredientAdded != nil {
//                let ingredientName = ingredientAdded!.getName()
//                var ingredientCell = IngredientTableViewCell(ingredient: ingredientAdded!)
//                ingredientCell.ingredientName.text = ingredientName
//                self.register(IngredientTableViewCell.self, forCellReuseIdentifier: ingredientName)
//                self.ingredients[ingredientName] = ingredientCell
//                self.beginUpdates()
//                self.insertRows(at: [IndexPath(row: lastIndex, section: 0)], with: .automatic)
//                lastIndex += 1
//                self.endUpdates()
//            }
        }
    }
    
}
