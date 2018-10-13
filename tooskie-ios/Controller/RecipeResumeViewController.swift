//
//  RecipeResumeViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 13/10/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class RecipeResumeViewController: UIViewController {
    
    var recipe: Recipe?
    
    @IBOutlet weak var recipePicture: UIImageView!
    @IBOutlet weak var recipeName: UILabel!

    @IBAction func startRecipe(_ sender: Any) {
        performSegue(withIdentifier: "LaunchRecipeStep", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != nil && segue.identifier == "LaunchRecipeStep" {
            let destVC : RecipeViewController = segue.destination as! RecipeViewController
            destVC.recipe = self.recipe
        }
    }
    
    private func configure() {
        if let recipe = self.recipe {
            self.recipeName.text = recipe.name
            if let pictureString = recipe.picture {
                let url = URL(string: pictureString)
                let data = try? Data(contentsOf: url!)
                if let data = data {
                    self.recipePicture.image = UIImage(data: data)
                }
                else {
                    self.recipePicture.image = UIImage(named: "NoNetwork")
                }
            }
        }
    }
}
