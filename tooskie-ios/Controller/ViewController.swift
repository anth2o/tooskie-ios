//
//  ViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 26/09/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var testText: UITextField!
    @IBAction func searchIngredient(_ sender: Any) {
        testText.text = checkIngredient()
    }
    
    func checkIngredient() -> String {
        if let text = searchBar.text {
            let ingredient = Ingredient(name: text)
            if pantry.contains(ingredient: ingredient){
                return ingredient.name
            }
        }
        return "Invalid ingredient"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pantry.addIngredient(ingredient: fromage)
        pantry.addIngredient(ingredient: poulet)
    }
}


