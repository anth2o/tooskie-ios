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

    @IBOutlet weak var recipePicture: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var stepNumber: UILabel!
    @IBOutlet weak var stepDescription: UILabel!
    @IBAction func previousStep(_ sender: Any) {
        if self.stepIndex > 1 {
            self.stepIndex -= 1
            self.updateStepDisplay()
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
    
    @IBAction func backToResume(_ sender: Any) {
        performSegue(withIdentifier: "BackToResume", sender: self)
    }
    
    @IBOutlet weak var progressStep: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != nil && segue.identifier == "BackToResume" {
            let destVC : RecipeResumeViewController = segue.destination as! RecipeResumeViewController
            destVC.recipe = self.recipe
            destVC.numberOfPerson = self.numberOfPerson
            destVC.recipes = self.recipes
        }
    }
    
    private func configure() {
        if let recipe = self.recipe {
            self.recipeName.text = recipe.name
            self.recipePicture.image = self.getPictureFromString(picture: recipe.picture)
            self.updateStepDisplay()
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
