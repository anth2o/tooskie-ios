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
    
    @IBOutlet weak var recipeView: SingleRecipe!
    
    @IBAction func cancelSwipe(_ sender: Any) {
        if self.index == 0 {
            performSegue(withIdentifier: "GoBack", sender: self)
        }
        if self.index > 0 && GlobalVariables.recipes.count > 0 {
            self.index -= 1
            self.recipeView!.setRecipe(recipe:GlobalVariables.recipes[self.index])
        }
    }
    
    @IBAction func validateRecipe(_ sender: UIButton) {
        recipeView.status = .accepted
        processRecipe()
    }
    
    @IBAction func passRecipe(_ sender: UIButton) {
        recipeView.status = .declined
        processRecipe()
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
            print(point.y)
            print(self.view.frame.minY)
            print(self.view.frame.maxY)
            sender.state = .cancelled
            self.recipeView.status = .waiting
        }
        if abs(point.x - self.view.frame.minX) < margin {
            sender.state = .ended
        }
        if abs(point.x - self.view.frame.maxX) < margin {
            print(self.view.frame.maxX)
            sender.state = .ended
        }
        print(sender.state.rawValue)
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
        print("Transform")
        let translation = gesture.translation(in: self.recipeView)
        
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        
        let translationPercent = translation.x/(UIScreen.main.bounds.width / 2)
        let rotationAngle = (CGFloat.pi / 6) * translationPercent
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        
        let transform = translationTransform.concatenating(rotationTransform)
        recipeView.transform = transform
        let speed = gesture.velocity(in: self.recipeView)
        print(speed.x)
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
        
        recipeView.transform = .identity
        let animationDurarion = 0.5
        UIView.animate(withDuration: animationDurarion) {
            self.recipeView.layoutIfNeeded()
        }
        recipeView.status = .waiting
    }
}
