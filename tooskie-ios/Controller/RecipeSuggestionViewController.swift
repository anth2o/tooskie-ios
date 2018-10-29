//
//  RecipeSuggestionViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 07/10/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class RecipeSuggestionViewController: UIViewController {
    
    var recipes = [Recipe]()
    var index = 0
    
    @IBOutlet weak var recipeView: SingleRecipe!
    
    @IBAction func goBack(_ sender: Any) {
        performSegue(withIdentifier: "GoBack", sender: self)
    }
    
    @IBAction func cancelSwipe(_ sender: Any) {
        if self.index > 0 && self.recipes.count > 0 {
            self.index -= 1
            self.recipeView!.setRecipe(recipe:self.recipes[self.index])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.recipes.count > 0 {
            self.recipeView!.setRecipe(recipe: self.recipes[self.index])
        }
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragRecipeView(_:)))
        recipeView.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != nil && segue.identifier == "LaunchRecipe" {
            let destVC : RecipeIntroViewController = segue.destination as! RecipeIntroViewController
            destVC.recipe = self.recipes[index]
            destVC.recipes = self.recipes
        }
    }
    
    @objc
    func dragRecipeView(_ sender: UIPanGestureRecognizer) {
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
        let translation = gesture.translation(in: recipeView)
        
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        
        let translationPercent = translation.x/(UIScreen.main.bounds.width / 2)
        let rotationAngle = (CGFloat.pi / 3) * translationPercent
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        
        let transform = translationTransform.concatenating(rotationTransform)
        recipeView.transform = transform
        if translation.x > 0 {
            recipeView.status = .accepted
        } else {
            recipeView.status = .declined
        }
    }
    
    private func processRecipe() {
        switch recipeView.status {
        case .accepted:
            if self.index < self.recipes.count {
                performSegue(withIdentifier: "LaunchRecipe", sender: self)
            }
        case .declined:
            index += 1
            if self.index < self.recipes.count {
                self.recipeView!.setRecipe(recipe: self.recipes[index])
            }
            else {
                performSegue(withIdentifier: "GoShopping", sender: self)
            }
        case .waiting:
            break
        }
        
        recipeView.transform = .identity
        recipeView.status = .waiting
    }
}
