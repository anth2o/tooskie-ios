//
//  Pantry.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 26/09/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import Foundation


class Pantry: Codable{
    private var id: Int?
    private var name: String
    private var ingredients: [Ingredient]
    public var count: Int{
        return self.ingredients.count
    }
    public var permaname: String? {
        if let slug = self.name.convertedToSlug(){
            return slug
        }
        return nil
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
    
    public func getIngredientByName(ingredientName: String) -> Ingredient? {
        if let index = self.getIndex(ingredient: Ingredient(name: ingredientName)) {
            return self.ingredients[index]
        }
        return nil
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
    
    public func getIngredientsByPrefix(prefix: String) -> [Ingredient]{
        let filtered = self.ingredients.filter { $0.getName().hasPrefix(prefix) }
        return filtered
    }
    
    public func getIngredientsToString() -> [String] {
        var ingredientsString = [String]()
        for i in 0..<self.ingredients.count {
            ingredientsString.append(self.ingredients[i].getName())
        }
        return ingredientsString
    }
    
    public func toPost() -> PostPantry {
        return PostPantry(name: self.name, ingredients: self.getIngredientsToString())
    }
}

struct PostPantry: Codable {
    let name: String
    let ingredients: [String]
}

