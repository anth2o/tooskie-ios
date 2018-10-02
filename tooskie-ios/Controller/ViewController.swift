//
//  ViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 26/09/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    let tooskiePantry = Pantry(name: "Tooskie pantry")
    var userPantry = Pantry(name: "User pantry")
    var serverConfig = ServerConfig()
    let loadAllIngredients = true

    
    @IBOutlet weak var pantryTableView: UITableView!
    @IBOutlet weak var ingredientSearchBar: UISearchBar!
    
    @IBAction func launchRecipes(_ sender: Any) {
        self.loadPantry()
    }
    
    @IBAction func ingredientSearchButton(_ sender: Any) {
        addIngredient()
    }
    
    func capitalize(string: String) -> String {
        return string.prefix(1).uppercased() + string.dropFirst()
    }
    
    func addIngredient(){
        if let text = ingredientSearchBar.text {
            let chosenIngredient = Ingredient(name: capitalize(string: text))
            if self.loadAllIngredients {
                if self.tooskiePantry.contains(ingredient: chosenIngredient){
                    userPantry.addIngredient(ingredient: chosenIngredient)
                    self.reload()
                    self.ingredientSearchBar.text = ""
                }
                else {
                    self.alertIngredientNotAvailable()
                }
            }
            else {
                self.requestAndAddIngredient(ingredient: chosenIngredient)
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
        if self.loadAllIngredients {
            self.loadPantry()
        }
        pantryTableView.delegate = self
        pantryTableView.dataSource = self
        ingredientSearchBar.delegate = self
        print("View did load")
    }
    
    func loadPantry() {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.serverConfig.getUrlScheme()
        urlComponents.host = self.serverConfig.getUrlHost()
        urlComponents.path = "/ingredient/"
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            DispatchQueue.main.async {
                if let error = responseError {
                    print(error.localizedDescription)
                } else if let jsonData = responseData {
                    let decoder = JSONDecoder()
                    do {
                        let ingredients = try decoder.decode([Ingredient].self, from: jsonData)
                        self.tooskiePantry.setIngredientList(list: ingredients)
                    } catch {
                        print("Error")
                    }
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
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
    
    func requestAndAddIngredient(ingredient: Ingredient) {
        if ingredient.permaname == nil {
            print("Ingredient " + ingredient.getName() + " hasn't a valid permaname")
            return
        }
        var urlComponents = URLComponents()
        urlComponents.scheme = self.serverConfig.getUrlScheme()
        urlComponents.host = self.serverConfig.getUrlHost()
        urlComponents.path = "/ingredient/" + ingredient.permaname!
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            DispatchQueue.main.async {
                if let error = responseError {
                    print(error.localizedDescription)
                } else if let jsonData = responseData {
                    let decoder = JSONDecoder()
                    do {
                        let ingredient = try decoder.decode(Ingredient.self, from: jsonData)
                        self.userPantry.addIngredient(ingredient: ingredient)
                    } catch {
                        print("Error")
                    }
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    private func reload(){
        self.pantryTableView.reloadData()
        if self.userPantry.count > 0 {
            try self.pantryTableView.scrollToRow(at: IndexPath(item: self.userPantry.count-1, section: 0), at: .top, animated: true)
        }
    }
}


