//
//  ShoppingListViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 11/01/2019.
//  Copyright © 2019 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController {
    
    fileprivate var suggestedSearchTable: SuggestedSearchTableViewController!
    
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let suggestedSearchTable = children.first as? SuggestedSearchTableViewController else  {
            fatalError("Check storyboard for missing SuggestedSearchTableViewController")
        }
        self.suggestedSearchTable = suggestedSearchTable
        self.suggestedSearchTable.bottomConstraintValue = stackView.frame.height
        self.suggestedSearchTable.searchTable.cellIdentifier = "Check"
        self.suggestedSearchTable.searchTable.keywordEnsemble = "la liste de courses"
        self.suggestedSearchTable.pantry = GlobalVariables.userShoppingList
    }
    
    @IBAction func deleteList(_ sender: Any) {
        print("Delete list")
    }
    
    @IBAction func addToPantry(_ sender: Any) {
        print("Add to pantry")
    }

}
