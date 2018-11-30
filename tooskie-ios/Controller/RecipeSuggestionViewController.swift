//
//  RecipeSuggestionViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 07/10/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class RecipeSuggestionViewController: UIViewController {
    
    var index = 0
    let defaultTranslationX = UIScreen.main.bounds.width / 2
    let defaultTranslationY = CGFloat(-50)
    let maxTranslationY = CGFloat(20)
    let minTranslationY = CGFloat(-60)
    let minY = CGFloat(120)
    let maxY = CGFloat(500)
    let animationDurarion = 0.2
    var translation = CGPoint(x: 0, y: 0)
    var speed = CGPoint(x: 0, y: 0)
    
    @IBOutlet weak var recipeView: SingleRecipe!
    
    @IBAction func goHome(_ sender: Any) {
        performSegue(withIdentifier: "RecipeSuggestionToHome", sender: self)
    }
    
    @IBAction func validateRecipe(_ sender: UIButton) {
        self.recipeView.status = .accepted
        let transform = self.transformRecipeView(x: self.defaultTranslationX, y: self.defaultTranslationY).0
        self.handleSwipeByButton(transform: transform)
    }
    
    @IBAction func passRecipe(_ sender: UIButton) {
        self.recipeView.status = .declined
        let transform = self.transformRecipeView(x: -1*self.defaultTranslationX, y: self.defaultTranslationY).0
        self.handleSwipeByButton(transform: transform)
    }
    
    private func handleSwipeByButton(transform: CGAffineTransform) {
        UIView.animate(withDuration: animationDurarion, animations: {
            self.recipeView.transform = transform
        }, completion: { (success) in
            if success {
                self.processRecipe()
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if GlobalVariables.recipes.count > 0 {
            self.recipeView!.setRecipe(recipe: GlobalVariables.recipes[self.index])
        }
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragRecipeView(_:)))
        recipeView.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != nil && segue.identifier == "LaunchRecipe" {
            let destVC : RecipeIntroViewController = segue.destination as! RecipeIntroViewController
            destVC.recipe = GlobalVariables.recipes[index]
        }
    }
    
    @objc
    func dragRecipeView(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self.view)
        let margin = CGFloat(5)
        var topMargin = margin
        var bottomMargin = margin
        if #available(iOS 11.0, *) {
            if let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top {
                topMargin += topPadding
            }
            if let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
                bottomMargin += bottomPadding
            }
        }
        if abs(point.y - self.view.frame.minY) < topMargin || abs(point.y - self.view.frame.maxY) < bottomMargin {
            sender.state = .cancelled
            self.recipeView.status = .waiting
        }
        if abs(point.x - self.view.frame.minX) < margin {
            sender.state = .ended
        }
        if abs(point.x - self.view.frame.maxX) < margin {
            sender.state = .ended
        }
        switch sender.state {
        case .began, .changed:
            transformRecipeViewWith(gesture: sender)
        case .ended, .cancelled:
            processRecipe()
        default:
            break
        }
    }
    
    private func transformRecipeViewWith(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.recipeView)
        let point = gesture.location(in: self.view)
        var translationPercent = CGFloat(0)
        var transform = CGAffineTransform()
        if (point.y >= minY && point.y <= maxY) {
            (transform, translationPercent) = self.transformRecipeView(x: translation.x, y: translation.y)
            self.recipeView.transform = transform
            self.speed = gesture.velocity(in: self.recipeView)
            self.translation = translation
        }
        else {
            translationPercent = self.translation.x/(UIScreen.main.bounds.width / 2)
        }
        if abs(translationPercent) > 0.65 || (abs(speed.x) > 600 && abs(translationPercent) > 0.35) {
            if translation.x > 0 {
                recipeView.status = .accepted
            } else {
                recipeView.status = .declined
            }
        }
        else {
            recipeView.status = .waiting
        }
    }
    
    private func transformRecipeView(x: CGFloat, y: CGFloat) -> (CGAffineTransform, CGFloat) {
        let translationTransform = CGAffineTransform(translationX: x, y: y)
        let translationPercent = x/(UIScreen.main.bounds.width / 2)
        let rotationAngle = (CGFloat.pi / 6) * translationPercent
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
    
        let transform = translationTransform.concatenating(rotationTransform)
        return (transform, translationPercent)
    }
    
    private func processRecipe() {
        switch recipeView.status {
        case .accepted:
            if self.index < GlobalVariables.recipes.count {
                performSegue(withIdentifier: "LaunchRecipe", sender: self)
                self.recipeView.isHidden = true
            }
        case .declined:
            index += 1
            if self.index < GlobalVariables.recipes.count {
                self.recipeView!.setRecipe(recipe: GlobalVariables.recipes[index])
            }
            else {
                performSegue(withIdentifier: "GoShopping", sender: self)
                self.recipeView.isHidden = true
            }
        case .waiting:
            break
        }
        
        UIView.animate(withDuration: animationDurarion, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.recipeView.transform = .identity
        }, completion:nil)
        recipeView.status = .waiting
    }
}
