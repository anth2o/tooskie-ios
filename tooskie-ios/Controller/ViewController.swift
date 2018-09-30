//
//  ViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 26/09/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    
    let tooskiePantry = Pantry()
    let fromage = Ingredient(name: "Fromage")
    let poulet = Ingredient(name: "Poulet")
    var userPantry = Pantry()
    
    @IBOutlet weak var ingredientSearchBar: UISearchBar!
    @IBOutlet weak var pantryTable: PantryTableView!
    
    @IBAction func ingredientSearchButton(_ sender: Any) {
        let ingredientAdded = addIngredient()
//        if !ingredientAdded{
//            textIngredient.text = "Ingrédient inconnu"
//        }
//        else{
//            textIngredient.text = ""
//        }
    }
    
    func addIngredient() -> Bool {
        if let text = ingredientSearchBar.text {
            let chosenIngredient = Ingredient(name: text)
            if tooskiePantry.contains(ingredient: chosenIngredient){
                pantryTable.addIngredient(ingredient: chosenIngredient)
                return true
            }
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tooskiePantry.addIngredient(ingredient: fromage)
        tooskiePantry.addIngredient(ingredient: poulet)
        pantryTable.pantry = userPantry
    }
}


