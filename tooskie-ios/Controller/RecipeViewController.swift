//
//  RecipeViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 13/10/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {
    
    var recipe: Recipe?
    var numberOfPerson = 1
    var stepIndex = 1
    var recipes = [Recipe]()
    var infoString = ""
    var ingredientsString = ""

    @IBOutlet weak var recipePicture: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeNameHelp: UILabel!
    @IBOutlet weak var recipePictureHelp: UIImageView!
    @IBOutlet weak var resumeOption: UISegmentedControl!
    @IBOutlet weak var resumeText: UITextView!
    @IBOutlet weak var stepNumber: UILabel!
    @IBOutlet weak var stepDescription: UITextView!
    @IBOutlet weak var progressStep: UIProgressView!
    @IBOutlet weak var helpView: UIView!
    
    @IBAction func previousStep(_ sender: Any) {
        if self.stepIndex > 1 {
            self.stepIndex -= 1
            self.updateStepDisplay()
        }
        else {
            performSegue(withIdentifier: "BackToIntro", sender: self)
        }
    }
    
    @IBAction func nextStep(_ sender: Any) {
        if let recipe = self.recipe {
            if let steps = recipe.steps {
                if self.stepIndex < steps.count {
                    self.stepIndex += 1
                    self.updateStepDisplay()
                }
            }
        }
    }
    
    @IBAction func displayHelp(_ sender: Any) {
        self.helpView.isHidden = false
        self.view.backgroundColor = UIColor.darkGray
    }
    
    @IBAction func hideHelp(_ sender: Any) {
        self.helpView.isHidden = true
        self.view.backgroundColor = UIColor.white
    }
    
    @IBAction func choseResumeOption(_ sender: Any) {
        switch resumeOption.selectedSegmentIndex
        {
        case 0:
            resumeText.text = self.infoString;
        case 1:
            resumeText.text = self.ingredientsString;
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.helpView.setBorder()
        self.helpView.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != nil && segue.identifier == "BackToIntro" {
            let destVC : RecipeIntroViewController = segue.destination as! RecipeIntroViewController
            destVC.recipe = self.recipe
            destVC.numberOfPerson = self.numberOfPerson
            destVC.recipes = self.recipes
        }
    }
    
    private func configure() {
        if let recipe = self.recipe {
            self.recipeName.text = recipe.name
            self.recipePicture.image = self.getPictureFromString(picture: recipe.picture)
            self.recipeNameHelp.text = recipe.name
            self.recipePictureHelp.image = self.getPictureFromString(picture: recipe.picture)
            self.setIngredientsString()
            self.setInfoString()
            self.resumeText.text = self.infoString
            self.updateStepDisplay()
        }
    }
    
    private func setIngredientsString() {
        if let recipe = self.recipe {
            if let ingredients = recipe.ingredients {
                self.ingredientsString = ""
                for i in 0..<ingredients.count {
                    let ingredient = ingredients[i]
                    let text = ingredient.getDescription(peopleNumber: self.numberOfPerson)
                    self.ingredientsString += text + "\n"
                }
            }
        }
    }
    
    private func setInfoString() {
        if let recipe = self.recipe {
            self.infoString = recipe.name
        }
    }
    
    private func updateStepDisplay() {
        if let step = self.recipe?.getStep(stepNumber: self.stepIndex) {
            self.stepNumber.text = "Etape " + String(self.stepIndex)
            if let description = step.description {
                self.stepDescription.text = description
            }
            if let length = self.recipe?.steps?.count {
                self.progressStep.setProgress(Float(self.stepIndex) / Float(length), animated: true)
            }
        }
    }
}
