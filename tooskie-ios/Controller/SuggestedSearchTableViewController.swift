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
    
    @IBOutlet weak var suggestionBar: SuggestionBarViewController!
    @IBOutlet weak var searchTableView: SearchTableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView._searchBar.delegate = self
        suggestionBar.view.isHidden = true
        suggestionBar.view.setBorder()
    }
}
