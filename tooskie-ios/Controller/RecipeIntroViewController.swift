//
//  RecipeIntroViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 13/10/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class RecipeIntroViewController: UIViewController, UITextFieldDelegate {
    
    var recipe: Recipe?
    var numberOfPerson = 1
    
    @IBOutlet weak var recipePicture: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var numberOfPersonButton: UIButton!
    @IBOutlet weak var numberOfPersonStepper: UIStepper!
    @IBOutlet weak var auxTempField: UITextField!
    @IBAction func numberOfPersonStepperChanged(_ sender: UIStepper) {
        self.numberOfPerson = Int(sender.value)
        self.setNumberOfPeopleButton()
        self.setIngredients()
    }
    @IBOutlet weak var ingredientsText: UITextView!
    @IBAction func startRecipe(_ sender: Any) {
        performSegue(withIdentifier: "LaunchRecipeStep", sender: self)
    }
    @IBAction func backToSuggestions(_ sender: Any) {
        performSegue(withIdentifier: "GoBackSuggestions", sender: self)
    }
    
    @IBAction func setNumberOfPeople(_ sender: UIButton) {
        print("Button clicked")
        auxTempField.becomeFirstResponder()
    }
    
    @IBAction func removeKeyboard(_ sender: UITapGestureRecognizer) {
        auxTempField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        auxTempField.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != nil && segue.identifier == "LaunchRecipeStep" {
            let destVC : RecipeViewController = segue.destination as! RecipeViewController
            destVC.recipe = self.recipe
            destVC.numberOfPerson = self.numberOfPerson
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
        self.setNumberOfPeopleButton()
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
    
    private func setNumberOfPeopleButton() {
        if self.numberOfPerson == 1 {
            self.numberOfPersonButton.setTitle(String(self.numberOfPerson) + " personne", for: .normal)
        }
        else {
            self.numberOfPersonButton.setTitle(String(self.numberOfPerson) + " personnes", for: .normal)
        }
    }
}
