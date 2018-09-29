//
//  ViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 26/09/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    
    @IBOutlet weak var ingredientSearchBar: UISearchBar!
    
    @IBAction func ingredientSearchButton(_ sender: Any) {
    }
    
    @IBOutlet weak var ingredientsInPantry: UITableView!
    
    func addIngredient() -> String {
        if let text = ingredientSearchBar.text {
            var chosenIngredient = Ingredient(name: text)
            if tooskiePantry.contains(ingredient: chosenIngredient){
                userPantry.addIngredient(ingredient: chosenIngredient)
                return chosenIngredient.name
            }
        }
        return "Invalid ingredient"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tooskiePantry.addIngredient(ingredient: fromage)
        tooskiePantry.addIngredient(ingredient: poulet)
    }
}


