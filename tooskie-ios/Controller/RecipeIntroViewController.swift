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
    var stringNumberOfPerson = ""
    
    @IBOutlet weak var recipePicture: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var numberOfPersonText: UITextField! {
        didSet { numberOfPersonText?.addDoneCancelToolbar() }
    }
    @IBOutlet weak var numberOfPersonStepper: UIStepper!
    
    var numberOfPerson = 1 {
        didSet {
            if self.numberOfPersonStepper != nil {
                self.numberOfPersonStepper.value = Double(numberOfPerson)
            }
        }
    }
    
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
    
    @IBAction func removeKeyboard(_ sender: UITapGestureRecognizer) {
        self.numberOfPersonText.resignFirstResponder()
    }
    @IBAction func removeKeyboardSwipe(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        if translation.y > 0 && abs(translation.y) > abs(translation.x) {
            _ = self.textFieldShouldReturn(self.numberOfPersonText)
        }
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
        self.numberOfPersonText.delegate = self
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
        if self.numberOfPerson <= 1 {
            self.numberOfPersonText.text = String(self.numberOfPerson) + " personne"
        }
        else {
            self.numberOfPersonText.text = String(self.numberOfPerson) + " personnes"
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.stringNumberOfPerson = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            self.stringNumberOfPerson = String(self.stringNumberOfPerson.dropLast())
        }
        else if Int(string) != nil {
            self.stringNumberOfPerson += string
        }
        else {
            return false
        }
        if self.stringNumberOfPerson == "" {
            self.numberOfPerson = 0
        }
        else {
            self.numberOfPerson = Int(self.stringNumberOfPerson)!
        }
        self.setNumberOfPeopleButton()
        self.setIngredients()
        return false
    }
    
    func doneButtonTappedForMyNumericTextField() {
        self.numberOfPersonText.resignFirstResponder()
    }
    
}
