//
//  ViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 26/09/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    let ingredientName = [
        "Fromage",
        "Poulet",
        "Pommes de terre",
        "Endives",
        "Foie gras",
        "Tomates"
    ]
    let tooskiePantry = Pantry(name: "Tooskie pantry")
    var userPantry = Pantry(name: "User pantry")
    
    @IBOutlet weak var pantryTableView: UITableView!
    @IBOutlet weak var ingredientSearchBar: UISearchBar!
    
    @IBAction func ingredientSearchButton(_ sender: Any) {
        addIngredient()
    }
    
    func capitalize(string: String) -> String {
        return string.prefix(1).uppercased() + string.dropFirst()
    }
    
    func addIngredient(){
        if let text = ingredientSearchBar.text {
            let chosenIngredient = Ingredient(name: capitalize(string: text))
            if tooskiePantry.contains(ingredient: chosenIngredient){
                userPantry.addIngredient(ingredient: chosenIngredient)
                self.reload()
                self.ingredientSearchBar.text = ""
            }
            else {
                self.alertIngredientNotAvailable()
            }

        }
    }
    
    func alertIngredientNotAvailable() {
        let alert = UIAlertController(title: "Erreur", message: "Cet ingrédient n'est pas disponible", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadPantry()
        pantryTableView.delegate = self
        pantryTableView.dataSource = self
        ingredientSearchBar.delegate = self
        print("View did load")
    }
    
    func loadPantry() {
        for i in 0..<self.ingredientName.count{
            let ingredient = Ingredient(name: self.ingredientName[i])
            self.tooskiePantry.addIngredient(ingredient: ingredient)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userPantry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "IngredientTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? IngredientTableViewCell  else {
            fatalError("The dequeued cell is not an instance of IngredientTableViewCell.")
        }

        let ingredient = self.userPantry.getIngredient(index: indexPath.row)
        cell.ingredientName.text = ingredient.getName()
        cell.ingredient = ingredient
        cell.viewController = self
        return cell
    }
    
    func removeIngredient(ingredient: Ingredient) {
        let potentielIndexIngredient = self.userPantry.getIndex(ingredient: ingredient)
        if let indexIngredient = potentielIndexIngredient {
            self.userPantry.removeIngredient(ingredient: ingredient)
            let indexPath = IndexPath(item: indexIngredient, section: 0)
            pantryTableView.deleteRows(at: [indexPath], with: .fade)
            self.reload()
        }
    }
    
    private func reload(){
//        DispatchQueue.main.async {
        self.pantryTableView.reloadData()
        if self.userPantry.count > 0 {
            try self.pantryTableView.scrollToRow(at: IndexPath(item: self.userPantry.count-1, section: 0), at: .top, animated: true)
        }
//        }
    }
}


