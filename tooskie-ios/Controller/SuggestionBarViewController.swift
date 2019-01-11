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
    // We suppose that the dictionnary we are going to search is a Pantry
    public var globalPantry = GlobalVariables.tooskiePantry
    // We suppose here that the table view is going to display a Pantry object (like a pantry, a checklist of ingredient, a list of ingredient intolerances...)
    // It would be useful to implement a more abstract protocol to use it for any array
    public var pantry = GlobalVariables.userPantry
    
    @IBOutlet weak var stackView: UIStackView!
    
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
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = UIStackView.Alignment.center
        addSubviews()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(notification:NSNotification) {
        view.isHidden = false
    }
    
    @objc
    func keyboardWillHide(notification:NSNotification) {
        view.isHidden = true
    }
    
    private func addSubviews() {
        for _ in 0..<self.numberWordsSuggested {
            let subview = UIView()
            subview.backgroundColor = UIColor.white
            subview.heightAnchor.constraint(equalToConstant: stackView.frame.height).isActive = true
            subview.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(subview)
            stackView.layoutSubviews()
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
            NotificationCenter.default.post(name: .suggestionPressed, object: self, userInfo: ["ingredient": ingredient])
            self.clearSuggestions()
        }
    }
    
    public func search(searchText: String) {
        if searchText.count >= minLettersSuggestion {
            let tempIngredientList = globalPantry.getIngredientsByPrefix(prefix: searchText)
            var ingredientCount = 0
            var wordSuggestedCount = 0
            // This loop "fills" the button of the suggestion bar
            // We could order the result by the relevancy of the ingredients
            while ingredientCount < tempIngredientList.count && wordSuggestedCount < self.numberWordsSuggested {
                let tempIngredient = tempIngredientList[ingredientCount]
                if !pantry.contains(ingredient: tempIngredient) {
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
