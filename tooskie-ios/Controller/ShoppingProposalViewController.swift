//
//  ShoppingProposalViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 26/10/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class ShoppingProposalViewController: UIViewController {
    
    @IBAction func goHome(_ sender: Any) {
        performSegue(withIdentifier: "ShoppingToHome", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
