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
    var stepIndex = 0

    @IBOutlet weak var recipePicture: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var stepNumber: UILabel!
    @IBOutlet weak var stepDescription: UILabel!
    
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
            if let step = self.recipe?.getStep(stepNumber: 1) {
                self.stepNumber.text = "Etape 1"
                if let description = step.description {
                    self.stepDescription.text = description
                }
            }
        }
    }
}
