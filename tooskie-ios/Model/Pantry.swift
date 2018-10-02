//
//  Pantry.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 26/09/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import Foundation


class Pantry{
    private var name: String
    private var ingredients: [Ingredient]
    public var count: Int{
        return self.ingredients.count
    }
    
    convenience init(){
        self.init(name: "Poulet")
    }
    
    init (name: String) {
        self.name = name
        self.ingredients = []
    }
    
    public func contains(ingredient: Ingredient) -> Bool {
        return self.ingredients.contains(where: {ingredient.equals(to: ($0))})
    }
    
    public func addIngredient(ingredient: Ingredient){
        if !self.contains(ingredient: ingredient){
            self.ingredients.append(ingredient)
        }
    }
    
    public func setIngredientList(list: [Ingredient]) {
        self.ingredients = list
    }
    
    public func removeIngredient(ingredient: Ingredient){
        self.ingredients.removeAll(where: {ingredient.equals(to: ($0))})
    }
    
    public func refresh() {
        self.ingredients = []
    }
    
    public func getIngredient(index: Int) -> Ingredient{
        return self.ingredients[index]
    }
    
    public func getIndex(ingredient: Ingredient) -> Int? {
        return self.ingredients.firstIndex(where: {$0.equals(to: ingredient)})
    }
}

