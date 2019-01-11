//
//  SuggestedSearchTableViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 10/01/2019.
//  Copyright © 2019 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class SuggestedSearchTableViewController: UIViewController, UISearchBarDelegate {
    
    private var keyboardIsVisible = false
    public var bottomConstraintValue = CGFloat(-100) {
        didSet {
            self.bottomConstraint.constant = bottomConstraintValue
        }
    }
    public var searchTable: SearchTableViewController!
    public var suggestionBar: SuggestionBarViewController!
    
    public var globalPantry = GlobalVariables.tooskiePantry {
        didSet {
            self.suggestionBar.globalPantry = globalPantry
            self.searchTable.globalPantry = globalPantry
        }
    }
    public var pantry =  GlobalVariables.userPantry {
        didSet {
            self.suggestionBar.pantry = pantry
            self.searchTable.pantry = pantry
        }
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var searchTableTemp = children.first as? SearchTableViewController
        var suggestionBarTemp = children.last as? SuggestionBarViewController
        if searchTableTemp == nil {
            searchTableTemp = children.last as? SearchTableViewController
            suggestionBarTemp = children.first as? SuggestionBarViewController
        }
        self.searchTable = searchTableTemp
        self.suggestionBar = suggestionBarTemp
        searchTable._searchBar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(searchPrefix), name: Notification.Name.suggestionPressed, object: nil)
    }
    
    @objc
    func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(show: true, notification: notification)
        keyboardIsVisible = true
    }
    
    @objc
    func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(show: false, notification: notification)
        keyboardIsVisible = false
    }
    
    @objc
    func searchPrefix(notification:NSNotification) {
        if notification.object as? SuggestionBarViewController != self.suggestionBar {
            return
        }
        if let data = notification.userInfo as? [String: Any]
        {
            let ingredient = data["ingredient"] as! Ingredient
            searchTable.addAndDisplayNewIngredient(ingredient: ingredient)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchTable.addIngredient()
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        if self.keyboardIsVisible == show {
            return
        }
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        bottomConstraint.constant -= (keyboardFrame.height - GlobalVariables.tabItemHeight + bottomConstraintValue) * (show ? 1 : -1)
        UIView.animate(withDuration: animationDurarion) {
            self.view.layoutIfNeeded()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        suggestionBar.search(searchText: searchText)
    }
}
