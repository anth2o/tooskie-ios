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
    public var bottomConstraintValue = CGFloat(100)
    fileprivate var searchTable: SearchTableViewController!
    fileprivate var suggestionBar: SuggestionBarViewController!
    
    @IBOutlet weak var suggestionBarView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(children)
        guard let searchTableTemp = children.last as? SearchTableViewController else  {
            fatalError("Check storyboard for missing SearchTableViewController")
        }
        guard let suggestionBarTemp = children.first as? SuggestionBarViewController else {
            fatalError("Check storyboard for missing SuggestionBarViewController")
        }
        self.searchTable = searchTableTemp
        self.suggestionBar = suggestionBarTemp
        suggestionBar.search(searchText: "fro")
        searchTable._searchBar.delegate = self
        bottomConstraint.constant = bottomConstraintValue
        view.layoutIfNeeded()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // add notification with children (suggestion pressed..)
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.searchTable._searchBar.resignFirstResponder()
    }
    
    @IBAction func dismissKeyboardSwipe(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        if translation.y > 0 && abs(translation.y) > abs(translation.x) {
            self.searchTable!._searchBar.resignFirstResponder()
        }
        if translation.y < 0 && abs(translation.y) > abs(translation.x) {
            self.searchTable!._searchBar.becomeFirstResponder()
        }
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
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        if self.keyboardIsVisible == show {
            return
        }
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        bottomConstraint.constant += (keyboardFrame.height - bottomConstraintValue - GlobalVariables.tabItemHeight) * (show ? 1 : -1)
        UIView.animate(withDuration: animationDurarion) {
            self.view.layoutIfNeeded()
        }
    }
}
