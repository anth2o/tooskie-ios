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
    
    init(){
        self.name = "tooskie"
        self.ingredients = []
    }
    
    func contains(ingredient: Ingredient) -> Bool {
        return self.ingredients.contains(where: {ingredient.equals(to: ($0))})
    }
    
    func addIngredient(ingredient: Ingredient){
        if !self.contains(ingredient: ingredient){
            self.ingredients.append(ingredient)
        }
    }
    
    func removeIngredient(ingredient: Ingredient){
        self.ingredients.removeAll(where: {ingredient.equals(to: ($0))})
    }
    
    func refresh() {
        self.ingredients = []
    }

}

var pantry = Pantry()
var fromage = Ingredient(name: "Fromage")
var poulet = Ingredient(name: "Poulet")
