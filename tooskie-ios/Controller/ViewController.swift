//
//  ViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 26/09/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tooskiePantry = Pantry()
    let fromage = Ingredient(name: "Fromage")
    let poulet = Ingredient(name: "Poulet")
    var userPantry = Pantry()
    
    @IBOutlet weak var pantryTableView: UITableView!
    @IBOutlet weak var ingredientSearchBar: UISearchBar!
    
    @IBAction func ingredientSearchButton(_ sender: Any) {
        if userPantry.count > 0 {
            print(userPantry.getIngredient(index: 0).getName())
        }
        addIngredient()
    }
    
    func addIngredient(){
        if let text = ingredientSearchBar.text {
            let chosenIngredient = Ingredient(name: text)
            if tooskiePantry.contains(ingredient: chosenIngredient){
                userPantry.addIngredient(ingredient: chosenIngredient)
                DispatchQueue.main.async { self.pantryTableView.reloadData() }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadPantry()
        pantryTableView.delegate = self
        pantryTableView.dataSource = self
        print("View did load")
    }
    
    func loadPantry() {
        tooskiePantry.addIngredient(ingredient: fromage)
        tooskiePantry.addIngredient(ingredient: poulet)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection")
        return self.userPantry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "IngredientTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? IngredientTableViewCell  else {
            fatalError("The dequeued cell is not an instance of IngredientTableViewCell.")
        }

        let ingredient = self.userPantry.getIngredient(index: indexPath.row)
        cell.ingredientName.text = ingredient.getName()
        return cell
    }
}


