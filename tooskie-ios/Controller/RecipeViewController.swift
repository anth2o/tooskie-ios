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
    var bottomConstraintConstant = 40
    var topConstraintConstant = 40
    
    enum Status {
        case back, forward, waiting
    }
    var status: Status = .waiting
    
    enum ViewDisplayed {
        case help, step
    }
    
    var viewDisplayed: ViewDisplayed = .step
//    var helpDisplayed = false

    @IBOutlet weak var recipePicture: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeNameHelp: UILabel!
    @IBOutlet weak var recipePictureHelp: UIImageView!
    @IBOutlet weak var resumeOption: UISegmentedControl!
    @IBOutlet weak var resumeText: UITextView!
    @IBOutlet weak var stepNumber: UILabel!
    @IBOutlet weak var stepDescription: UITextView!
    @IBOutlet weak var progressStep: UIProgressView!
    @IBOutlet weak var stepView: UIView!
    @IBOutlet weak var helpView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBAction func previousStep(_ sender: Any) {
        self.stepBack(swipe: false)
    }
    
    @IBAction func nextStep(_ sender: Any) {
        self.stepForward()
    }
    
    @IBAction func displayHelp(_ sender: Any) {
        self.viewDisplayed = .help
        self.updateViewDisplayed()
//        self.helpDisplayed = true
    }
    
    @IBAction func hideHelp(_ sender: Any) {
        self.viewDisplayed = .step
        self.updateViewDisplayed()
//        self.helpDisplayed = false
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
        self.helpView.alpha = 1
//        self.bottomConstraint.constant = -1 * self.helpView.frame.height
//        self.bottomConstraint.constant = -1 * self.helpView.frame.height
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        self.stepView.addGestureRecognizer(panGestureRecognizer)
        self.updateViewDisplayed()
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
    
    private func updateViewDisplayed () {
//        var show = false
        switch self.viewDisplayed {
        case .step:
            self.helpView.isHidden = true
            self.view.backgroundColor = UIColor.white
            self.stepView.backgroundColor = UIColor.white
        case .help:
            self.helpView.isHidden = false
            self.view.backgroundColor = UIColor.darkGray
            self.stepView.backgroundColor = UIColor.darkGray
//            show = true
        }
//        if self.helpDisplayed == show {
//            return
//        }
//        let viewFrame = self.helpView.frame
//        let animationDurarion = 0.5
//        let changeInHeight = (viewFrame.height + CGFloat(self.bottomConstraintConstant)) * (show ? 1 : -1)
//        self.bottomConstraint.constant += changeInHeight
//        UIView.animate(withDuration: animationDurarion) {
//            self.helpView.layoutIfNeeded()
//        }
    }
    
    private func stepBack(swipe: Bool) {
        if self.stepIndex > 1 {
            self.stepIndex -= 1
            self.updateStepDisplay()
        }
        else {
            if !swipe {
                performSegue(withIdentifier: "BackToIntro", sender: self)
            }
        }
    }
    
    private func stepForward () {
        if let recipe = self.recipe {
            if let steps = recipe.steps {
                if self.stepIndex < steps.count {
                    self.stepIndex += 1
                    self.updateStepDisplay()
                }
            }
        }
    }
    
    @objc
    private func handleSwipe(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            getTranslationData(gesture: sender)
        case .ended, .cancelled:
            processStep()
        default:
            break
        }
    }
    
    private func getTranslationData(gesture: UIPanGestureRecognizer) {
        print("Transform")
        let translation = gesture.translation(in: self.view)
        let translationPercent = translation.x/(UIScreen.main.bounds.width / 2)
        if abs(translationPercent) > 0.25 && abs(translation.x) > 2 * abs(translation.y){
            if translation.x < 0 {
                self.status = .forward
            } else {
                self.status = .back
            }
        }
        else {
            self.status = .waiting
        }
    }
    
    private func processStep() {
        switch self.status {
        case .forward:
            stepForward()
        case .back:
            stepBack(swipe: true)
        case .waiting:
            break
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
            if let preparationTime = recipe.preparationTime {
                self.infoString += "Temps de préparation: " + String(preparationTime) + " min\n"
            }
            if let cookingTime = recipe.cookingTime {
                self.infoString += "Temps de cuisson: " + String(cookingTime) + " min\n"
            }
            if let budgetLevel = recipe.budgetLevel {
                self.infoString += "Budget: " + budgetLevel + "\n"
            }
            if let difficultyLevel = recipe.difficultyLevel {
                self.infoString += "Difficulté: " + difficultyLevel + "\n"
            }
            if let numberOfSteps = recipe.numberOfSteps {
                self.infoString += "Nombre d'étapes: " + String(numberOfSteps) + "\n"
            }
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
