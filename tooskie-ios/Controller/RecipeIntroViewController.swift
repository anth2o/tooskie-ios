//
//  RecipeIntroViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 13/10/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class RecipeIntroViewController: UIViewController {
    
    var recipe: Recipe?
    var numberOfPerson = 1
    var recipes = [Recipe]()
    
    
    @IBOutlet weak var recipePicture: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var numberOfPersonLabel: UILabel!
    @IBOutlet weak var numberOfPersonStepper: UIStepper!
    @IBAction func numberOfPersonStepperChanged(_ sender: UIStepper) {
        self.numberOfPerson = Int(sender.value)
        self.setNumberOfPeopleLabel()
        self.setIngredients()
    }
    @IBOutlet weak var ingredientsText: UITextView!
    @IBAction func startRecipe(_ sender: Any) {
        performSegue(withIdentifier: "LaunchRecipeStep", sender: self)
    }
    @IBAction func backToSuggestions(_ sender: Any) {
        performSegue(withIdentifier: "GoBackSuggestions", sender: self)
    }
    
override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != nil && segue.identifier == "LaunchRecipeStep" {
            let destVC : RecipeViewController = segue.destination as! RecipeViewController
            destVC.recipe = self.recipe
            destVC.numberOfPerson = self.numberOfPerson
            destVC.recipes = self.recipes
        }
        if segue.identifier != nil && segue.identifier == "GoBackSuggestions" {
            let destVC : RecipeSuggestionViewController = segue.destination as! RecipeSuggestionViewController
            destVC.recipes = self.recipes
        }
    }
    
    private func configure() {
        if let recipe = self.recipe {
            self.recipeName.text = recipe.name
            if let pictureData = recipe.getPictureData() {
                self.recipePicture.image = UIImage(data: pictureData)
            }
            else {
                self.recipePicture.image = UIImage(named: "NoNetwork")
            }
        }
        self.setNumberOfPeopleLabel()
        self.numberOfPersonStepper.value = Double(self.numberOfPerson)
        self.numberOfPersonStepper.autorepeat = true
        self.numberOfPersonStepper.minimumValue = 1
        self.ingredientsText.isEditable = false
        self.setIngredients()
    }
    
    private func setIngredients() {
        if let recipe = self.recipe {
            if let ingredients = recipe.ingredients {
                self.ingredientsText.text = ""
                for i in 0..<ingredients.count {
                    let ingredient = ingredients[i]
                    let text = ingredient.getDescription(peopleNumber: self.numberOfPerson)
                    self.ingredientsText.text += text + "\n"
                }
            }
        }
    }
    
    private func setNumberOfPeopleLabel() {
        if self.numberOfPerson == 1 {
            self.numberOfPersonLabel.text = String(self.numberOfPerson) + " personne"
        }
        else {
            self.numberOfPersonLabel.text = String(self.numberOfPerson) + " personnes"
        }
    }
}
