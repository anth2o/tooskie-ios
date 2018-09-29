//
//  Pantry.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 26/09/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import Foundation


class Pantry{
    var name: String
    var ingredients: [Ingredient]
    
    convenience init(){
        self.init(name: "Poulet")
    }
    
    init (name: String) {
        self.name = name
        self.ingredients = []
    }
    
    func contains(ingredient: Ingredient) -> Bool {
        return self.ingredients.contains(where: {ingredient.equals(to: ($0))})
    }
    
    func addIngredient(ingredient: Ingredient) -> Ingredient?{
        if !self.contains(ingredient: ingredient){
            self.ingredients.append(ingredient)
            return ingredient
        }
        return nil
    }
    
    func removeIngredient(ingredient: Ingredient){
        self.ingredients.removeAll(where: {ingredient.equals(to: ($0))})
    }
    
    func refresh() {
        self.ingredients = []
    }

}

var tooskiePantry = Pantry()
var fromage = Ingredient(name: "Fromage")
var poulet = Ingredient(name: "Poulet")
var userPantry = Pantry()

