//
//  SearchTableViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 10/01/2019.
//  Copyright © 2019 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class SearchTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    private var rowHeight = CGFloat(60.0)
    private var keyboardIsVisible = false
    
    private enum IngredientAlert {
        case already, unknown
    }
    
    @IBOutlet weak var _tableView: UITableView!
    @IBOutlet weak var _searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.rowHeight = self.rowHeight
        _tableView.scrollToBottom()
        _searchBar.delegate = self
        _searchBar.backgroundImage = UIImage()
        self.view.setBorder(borderWidth: 3.0)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search and add ingredient")
        self.addIngredient()
    }
    
    func addIngredient(){
        if let text = _searchBar.text {
            if text.count == 0 {
                self._searchBar.resignFirstResponder()
                return
            }
            if let chosenIngredient = GlobalVariables.tooskiePantry.getIngredientByName(ingredientName: text.capitalize()){
                if GlobalVariables.userPantry.contains(ingredient: chosenIngredient) {
                    self.alertIngredient(status: .already)
                    self._searchBar.text = ""
                }
                else {
                    self.addAndDisplayNewIngredient(ingredient: chosenIngredient)
                }
            }
            else {
                self.alertIngredient(status: .unknown)
            }
        }
    }
    
    func addAndDisplayNewIngredient(ingredient: Ingredient) {
        GlobalVariables.userPantry.addIngredient(ingredient: ingredient)
        _tableView.reloadData()
        _tableView.scrollToBottom()
        _searchBar.text = ""
    }
    
    func removeIngredient(ingredient: Ingredient) {
        let potentialIndexIngredient = GlobalVariables.userPantry.getIndex(ingredient: ingredient)
        if let indexIngredient = potentialIndexIngredient {
            GlobalVariables.userPantry.removeIngredient(ingredient: ingredient)
            let indexPath = IndexPath(item: indexIngredient, section: 0)
            _tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    private func alertIngredient(status: IngredientAlert) {
        var message = ""
        var title = ""
        switch status
        {
        case .already:
            message = "Cet ingrédient est déjà présent dans le garde-manger"
            title = "Déjà là";
        case .unknown:
            message = "Cet ingrédient n'est pas disponible"
            title = "Erreur";
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalVariables.userPantry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Poulet"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? IngredientTableViewCell  else {
            fatalError("The dequeued cell is not an instance of IngredientTableViewCell.")
        }
        
        let ingredient = GlobalVariables.userPantry.getIngredient(index: indexPath.row)
        cell.ingredient = ingredient
        cell.viewController = self
        cell.ingredientName.text = ingredient.getName()
        if let pictureData = ingredient.getPictureData() {
            cell.ingredientPicture.image = UIImage(data: pictureData)
        }
        else {
            cell.ingredientPicture.image = UIImage(named: "NoNetwork")
        }
        if #available(iOS 11.0, *) {
            cell.userInteractionEnabledWhileDragging = false
        }
        cell.selectionStyle = .none
        return cell    }
}
