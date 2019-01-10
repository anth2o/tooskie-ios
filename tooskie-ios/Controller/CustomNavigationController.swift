//
//  CustomNavigationController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 10/01/2019.
//  Copyright © 2019 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

    @IBOutlet weak var tabItem: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabItemView = self.tabItem.value(forKey: "view") as? UIView
        let tabItemHeight = tabItemView?.frame.height
        if let height = tabItemHeight {
            GlobalVariables.tabItemHeight = height
        }
    }
}
