//
//  SuggestionBarViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 10/01/2019.
//  Copyright © 2019 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class SuggestionBarViewController: UIViewController {
    
    private var keyboardIsVisible = false
    private let minLettersSuggestion = 1
    private let numberWordsSuggested = 2
    private var currentIngredient: Ingredient?
    private var listSuggestedWord  = [SuggestedWord]()
    private var stackView = UIStackView()
    
    struct SuggestedWord {
        var view = UIView()
        var button = UIButton()
        var ingredient: Ingredient?
        
        init(view: UIView){
            self.view = view
        }
        
        init(view: UIView, button: UIButton){
            self.button = button
            self.view = view
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("suggestion bar loaded")
        stackView.backgroundColor = UIColor.white
        stackView.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackView)
    }
    
    private func addSubviews() {
        for _ in 0..<self.numberWordsSuggested {
            let subview = UIView()
            subview.backgroundColor = UIColor.white
            subview.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
            subview.translatesAutoresizingMaskIntoConstraints = false
            self.stackView.addArrangedSubview(subview)
            self.stackView.layoutSubviews()
            let suggestedWord = SuggestedWord(view: subview)
            self.listSuggestedWord.append(suggestedWord)
        }
        for i in 0..<self.numberWordsSuggested {
            let subview = self.listSuggestedWord[i].view
            let button = UIButton()
            button.titleLabel?.textAlignment = .center
            button.setTitle("", for: .normal)
            button.titleLabel?.textColor = UIColor.white
            button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            button.setBorder(color: customGreen.cgColor, cornerRadius: CGFloat(4))
            button.backgroundColor = customGreen
            button.tag = i
            button.addTarget(self, action: #selector(pressButton(_:)), for: .touchUpInside)
            button.titleLabel?.lineBreakMode = .byTruncatingTail
            subview.addSubview(button)
            button.centerXAnchor.constraint(equalTo: subview.centerXAnchor).isActive = true
            button.centerYAnchor.constraint(equalTo: subview.centerYAnchor).isActive = true
            button.heightAnchor.constraint(equalToConstant: 2*subview.frame.height/3).isActive = true
            button.widthAnchor.constraint(lessThanOrEqualToConstant: 4*subview.frame.width/5).isActive = true
            button.translatesAutoresizingMaskIntoConstraints = false
            button.isHidden = true
            self.listSuggestedWord[i].button = button
        }
    }
    
    @objc func pressButton(_ button: UIButton) {
        if let ingredient = self.listSuggestedWord[button.tag].ingredient {
            print(ingredient)
            self.clearSuggestions()
//            self.addAndDisplayNewIngredient(ingredient: ingredient)
        }
    }
    
    public func search(searchText: String) {
        if searchText.count >= minLettersSuggestion {
            let tempIngredientList = GlobalVariables.tooskiePantry.getIngredientsByPrefix(prefix: searchText)
            var ingredientCount = 0
            var wordSuggestedCount = 0
            while ingredientCount < tempIngredientList.count && wordSuggestedCount < self.numberWordsSuggested {
                let tempIngredient = tempIngredientList[ingredientCount]
                if !GlobalVariables.userPantry.contains(ingredient: tempIngredient) {
                    self.listSuggestedWord[wordSuggestedCount].button.setTitle(tempIngredient.getName(), for: .normal)
                    self.listSuggestedWord[wordSuggestedCount].button.isHidden = false
                    self.listSuggestedWord[wordSuggestedCount].ingredient = tempIngredient
                    wordSuggestedCount += 1
                }
                ingredientCount += 1
            }
            // Next loop hides unused buttons
            for i in wordSuggestedCount..<self.numberWordsSuggested {
                self.listSuggestedWord[i].button.isHidden = true
                self.listSuggestedWord[i].button.setTitle("", for: .normal)
                self.listSuggestedWord[i].ingredient = nil
            }
        }
        else {
            self.clearSuggestions()
        }
    }
    
    private func clearSuggestions() {
        for i in 0..<self.numberWordsSuggested {
            self.listSuggestedWord[i].button.isHidden = true
            self.listSuggestedWord[i].button.setTitle("", for: .normal)
            self.listSuggestedWord[i].ingredient = nil
            
        }
    }
}
