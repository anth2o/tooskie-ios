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
    var stepIndex = 1

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
    @IBOutlet weak var progressStep: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
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
