//
//  SearchTableViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 10/01/2019.
//  Copyright © 2019 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class SearchTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    private var listOfWords = GlobalVariables.tooskiePantry.getIngredientsToString()
    private var keywordElement = "ingrédient"
    private var keywordEnsemble = "le garde-manger"
    private var cellIdentifier = "Poulet"
    private enum StatusAlert {
        case already, unknown
    }
    
    @IBOutlet weak var _tableView: UITableView!
    @IBOutlet weak var _searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.scrollToBottom()
        _tableView.rowHeight = CGFloat(60)
        _searchBar.delegate = self
        _searchBar.backgroundImage = UIImage()
        _searchBar.placeholder = "Ajouter ingrédient"
        self.view.setBorder(borderWidth: 3.0)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(notification:NSNotification) {
        _tableView.isUserInteractionEnabled = false
        _searchBar.setImage(UIImage(), for: .search, state: .normal)
    }
    
    @objc
    func keyboardWillHide(notification:NSNotification) {
        _tableView.isUserInteractionEnabled = true
        _searchBar.setImage(nil, for: .search, state: .normal)
    }
    
    public func setKeywordElement(text: String) {
        keywordElement = text
    }
    
    public func setKeywordEnsemble(text: String) {
        keywordEnsemble = text
    }
    
    public func setCellIdentifier(text: String) {
        cellIdentifier = text
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.addIngredient()
    }
    
    public func addIngredient(){
        if let text = _searchBar.text {
            if text.count == 0 {
                _searchBar.resignFirstResponder()
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
    
    private func alertIngredient(status: StatusAlert) {
        var message = ""
        var title = ""
        switch status
        {
        case .already:
            message = "Cet " + keywordElement + " est déjà présent dans " + keywordEnsemble
            title = "Déjà là";
        case .unknown:
            message = "Cet " + keywordElement + " n'est pas disponible"
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
//        Implement this in a general way (without IngredientTableViewCell)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? IngredientTableViewCell  else {
            fatalError("The dequeued cell is not an instance of " + cellIdentifier)
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
