//
//  UIViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 29/09/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class PantryFillViewController: UIViewController {
    private var pantryPosted = false {
        didSet {
            self.getRecipes()
        }
    }
    private var recipes = GlobalVariables.recipes{
        didSet {
            GlobalVariables.recipes = recipes
            if recipes.count > 0 {
                performSegue(withIdentifier: "RecipeSuggestion", sender: self)
            }
            else {
                performSegue(withIdentifier: "PantryToShopping", sender: self)
            }
        }
    }

    private var tooskiePantryLoaded = false {
        didSet {
            if GlobalVariables.pantriesLoaded || (self.tooskiePantryLoaded && self.userPantryLoaded) {
                self.activityView.stopAnimation()
                GlobalVariables.pantriesLoaded = true
            }
        }
    }
    private var userPantryLoaded = false {
        didSet {
            if GlobalVariables.pantriesLoaded || (self.tooskiePantryLoaded && self.userPantryLoaded) {
                self.activityView.stopAnimation()
                GlobalVariables.pantriesLoaded = true
            }
        }
    }
    
    fileprivate var suggestedSearchTable: SuggestedSearchTableViewController!


//    Outlets
    @IBOutlet weak var launchButton: UIButton!
    @IBOutlet weak var activityView: ActivityView!
    
//    Actions
    @IBAction func launchRecipes(_ sender: Any) {
        self.activityView.startAnimation(title: "Génération de recettes en cours")
        self.sendPantry()
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        suggestedSearchTable.searchTable._searchBar!.resignFirstResponder()
    }

    @IBAction func dismissKeyboardSwipe(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        if translation.y > 0 && abs(translation.y) > abs(translation.x) {
            suggestedSearchTable.searchTable._searchBar!.resignFirstResponder()
        }
        if translation.y < 0 && abs(translation.y) > abs(translation.x) {
            suggestedSearchTable.searchTable._searchBar!.becomeFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let suggestedSearchTable = children.first as? SuggestedSearchTableViewController else  {
            fatalError("Check storyboard for missing SuggestedSearchTableViewController")
        }
        self.suggestedSearchTable = suggestedSearchTable
        self.suggestedSearchTable.bottomConstraintValue = -1 * launchButton.frame.height
        self.suggestedSearchTable.searchTable.cellIdentifier = "PictureDelete"
        self.loadPantry()
        self.loadUserPantry()
        self.configureActivityView()
        if !GlobalVariables.pantriesLoaded {
            self.activityView.startAnimation(title: "Chargement des ingrédients")
        }
    }
    
    private func configureActivityView() {
        self.activityView = Bundle.main.loadNibNamed("ActivityView", owner: self, options: nil)?.first as? ActivityView
        self.view.addSubview(activityView)
        self.activityView.backgroundColor = customGreen
        self.activityView.alpha = 1
        self.activityView.isHidden = true
    }

    func loadPantry() {
        if GlobalVariables.tooskiePantry.count > 0 {
            return
        }
        let request = GlobalVariables.serverConfig.getRequest(path: "/api/ingredient/", method: "GET")
        let session = GlobalVariables.serverConfig.getSession()
         let task = session.dataTask(with: request) { (data, response, responseError) in
            DispatchQueue.main.async {
                if let response = response {
                    print(response)
                }
                if let error = responseError {
                    print(error.localizedDescription)
                } else if let jsonData = data {
                    let decoder = JSONDecoder()
                    do {
                        let ingredients = try decoder.decode([Ingredient].self, from: jsonData)
                        GlobalVariables.tooskiePantry.setIngredientList(list: ingredients)
                        self.tooskiePantryLoaded = true
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
    
    func loadUserPantry() {
        if GlobalVariables.userPantry.count > 0 {
            return
        }
        if let permaname = GlobalVariables.userPantry.permaname {
            let request = GlobalVariables.serverConfig.getRequest(path: "/api/pantry/" + permaname, method: "GET")
            let session = GlobalVariables.serverConfig.getSession()
            let task = session.dataTask(with: request) { (data, response, responseError) in
                DispatchQueue.main.async {
                    if let response = response {
                        print(response)
                    }
                    if let error = responseError {
                        print(error.localizedDescription)
                    } else if let jsonData = data {
                        let decoder = JSONDecoder()
                        do {
                            let ingredients = try decoder.decode([Ingredient].self, from: jsonData)
                            GlobalVariables.userPantry.setIngredientList(list: ingredients)
                            for ingredient in GlobalVariables.userPantry.getIngredients() {
                                _ = ingredient.getPictureData()
                            }
                            self.suggestedSearchTable.searchTable._tableView!.reloadData()
                            self.suggestedSearchTable.searchTable._tableView!.scrollToBottom()
                        } catch {
                            print("Error")
                        }
                        self.userPantryLoaded = true
                    } else {
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
        }
    }
    
    func sendPantry() {
        let myPost = GlobalVariables.userPantry.toPost()
        var request = GlobalVariables.serverConfig.getRequest(path: "/api/pantry/", method: "POST")
        let session = GlobalVariables.serverConfig.getSession()
        request = GlobalVariables.serverConfig.encodeDataForPost(post: myPost, request: request)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            if let data = data, let utf8Representation = String(data: data, encoding: .utf8) {
                print("response: ", utf8Representation)
                self.pantryPosted = true
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
    
    public func getRecipes() {
        if let permaname = GlobalVariables.userPantry.permaname {
            let session = GlobalVariables.serverConfig.getSession()
            let request = GlobalVariables.serverConfig.getRequest(path: "/api/recipe-with-pantry/" + permaname, method: "GET")
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                DispatchQueue.main.async {
                    if let error = responseError {
                        print(error.localizedDescription)
                    } else if let jsonData = responseData {
                        let decoder = JSONDecoder()
                        do {
                            let recipes = try decoder.decode([Recipe].self, from: jsonData)
                            self.recipes = recipes
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
    }
}


