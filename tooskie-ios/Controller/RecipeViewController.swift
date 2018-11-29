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
    var infoString = ""
    var ingredientsString = ""
    let bottomConstraintConstant = CGFloat(40)
    let topConstraintConstant = CGFloat(40)
    var helpHeight = CGFloat(0)
    let tintView = UIView()
    
    enum Status {
        case back, forward, waiting
    }
    var status: Status = .waiting
    
    enum ViewDisplayed {
        case help, step
    }
    
    var viewDisplayed: ViewDisplayed = .step
    var helpDisplayed = false
    var goHome = false {
        didSet {
            if goHome {
                performSegue(withIdentifier: "GoHomeFromRecipe", sender: self)
            }
        }
    }

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
    @IBOutlet weak var nextStepDisplay: UIButton!
    
    @IBAction func previousStep(_ sender: Any) {
        self.stepBack(swipe: false)
    }
    
    @IBAction func nextStep(_ sender: Any) {
        self.stepForward()
    }
    
    @IBAction func displayHelp(_ sender: Any) {
        self._displayHelp()
    }
    
    private func _displayHelp() {
        self.viewDisplayed = .help
        self.updateViewDisplayed()
        self.helpDisplayed = true
    }
    
    @IBAction func hideHelp(_ sender: Any) {
        self._hideHelp()
    }
    
    private func _hideHelp() {
        self.viewDisplayed = .step
        self.updateViewDisplayed()
        self.helpDisplayed = false
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
    @IBAction func backHome(_ sender: Any) {
        let alert = UIAlertController(title: "Revenir à l'accueil", message: "Êtes vous sûr de vouloir revenir à l'écran d'accueil ?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Accueil", style: .destructive, handler: { action in
            print("Go home")
            self.goHome = true
        }))
        alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: { action in
            print("Cancel")
            print(action)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.handleConstraint()
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
        self.updateViewDisplayed()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != nil && segue.identifier == "BackToIntro" {
            let destVC : RecipeIntroViewController = segue.destination as! RecipeIntroViewController
            destVC.recipe = self.recipe
            destVC.numberOfPerson = self.numberOfPerson
        }
    }
    
    private func configure() {
        if let recipe = self.recipe {
            self.recipeName.text = recipe.name
            if let pictureData = recipe.getPictureData() {
                self.recipePicture.image = UIImage(data: pictureData)
                self.recipePictureHelp.image = UIImage(data: pictureData)
            }
            else {
                self.recipePicture.image = UIImage(named: "NoNetwork")
                self.recipePictureHelp.image = UIImage(named: "NoNetwork")

            }
            self.recipeNameHelp.text = recipe.name
            self.setIngredientsString()
            self.setInfoString()
            self.resumeText.text = self.infoString
            self.updateStepDisplay()
        }
        self.helpView.alpha = 1
        self.helpView.isHidden = false
        self.tintView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.tintView.frame = CGRect(x: self.recipePicture.contentClippingRect.minX, y: self.recipePicture.contentClippingRect.minY, width: self.recipePicture.contentClippingRect.width, height: self.recipePicture.contentClippingRect.height)
        self.tintView.isOpaque = false
    }
    
    private func handleConstraint() {
        self.bottomConstraint.constant = self.bottomConstraintConstant
        self.topConstraint.constant = self.topConstraintConstant
        self.helpHeight = self.helpView.frame.height
        self.topConstraint.constant = self.view.frame.height
        self.bottomConstraint.constant = -1 * self.helpHeight
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

    private func updateStepDisplay() {
        if let step = self.recipe?.getStep(stepNumber: self.stepIndex) {
            if let length = self.recipe?.steps?.count {
                self.progressStep.setProgress(Float(self.stepIndex) / Float(length), animated: true)
                if self.stepIndex == length {
                    self.nextStepDisplay.isEnabled = false
//                    self.nextStepDisplay.setTitle("Fini", for: .normal)
                }
                else {
                    self.nextStepDisplay.isEnabled = true
//                    self.nextStepDisplay.setTitle("Suivant", for: .normal)
                }
            }
            self.stepNumber.text = "Etape " + String(self.stepIndex)
            if let description = step.description {
                self.stepDescription.text = description
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
        var translationPercent = translation.x/(UIScreen.main.bounds.width / 2)
        if abs(translationPercent) > 0.25 && abs(translation.x) > 2 * abs(translation.y){
            if translation.x < 0 {
                self.status = .forward
            } else {
                self.status = .back
            }
        }
        else {
            self.status = .waiting
            translationPercent = translation.y/(UIScreen.main.bounds.height / 2)
            let margin = CGFloat(0.25)
            if translationPercent > margin && abs(translation.y) > abs(translation.x) && self.helpDisplayed {
                self.viewDisplayed = .step
            }
            if translationPercent < -1*margin && abs(translation.y) > abs(translation.x) && !self.helpDisplayed {
                self.viewDisplayed = .help
            }
        }
    }
    
    private func processStep() {
        switch self.status {
        case .forward:
            stepForward()
        case .back:
            stepBack(swipe: true)
        case .waiting:
            switch self.viewDisplayed {
            case .step:
                self._hideHelp()
            case .help:
                self._displayHelp()
            }
        }
    }
    
    
    
    private func updateViewDisplayed () {
        var show = false
        switch self.viewDisplayed {
        case .step:
            self.view.backgroundColor = UIColor.white
            self.stepView.backgroundColor = UIColor.white
            self.tintView.removeFromSuperview()
            self.helpView.removeBorder()
        case .help:
            self.view.backgroundColor = UIColor.darkGray
            self.stepView.backgroundColor = UIColor.darkGray
            self.recipePicture.addSubview(tintView)
            self.helpView.setBorder()
            show = true
        }
        if self.helpDisplayed == show {
            return
        }
        let animationDurarion = 0.5
        if show {
            self.bottomConstraint.constant = self.bottomConstraintConstant
            self.topConstraint.constant = self.topConstraintConstant
        }
        else {
            self.topConstraint.constant = self.view.frame.height
            self.bottomConstraint.constant = -1 * self.helpHeight
        }
        UIView.animate(withDuration: animationDurarion) {
            self.view.layoutIfNeeded()
            self.helpView.layoutIfNeeded()
            self.stepView.layoutIfNeeded()
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
}
