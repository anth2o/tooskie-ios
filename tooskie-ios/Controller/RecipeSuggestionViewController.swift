//
//  RecipeSuggestionViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 07/10/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class RecipeSuggestionViewController: UIViewController {
    
    var serverConfig = ServerConfig()
    var recipes = [Recipe]()
    
    @IBOutlet weak var recipeView: SingleRecipe!

    @IBAction func goBack(_ sender: Any) {
        performSegue(withIdentifier: "GoBack", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.recipes.count > 0 {
            self.recipeView!.setRecipe(recipe: self.recipes[0])
        }
    }
    
}
