//
//  Ingredient.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 26/09/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import Foundation
import UIKit

class Ingredient {
    var name: String
    var picture: String?
    
    init(name: String) {
        self.name = name
    }
    
    convenience init() {
        self.init(name: "Poulet")
    }
    
    func equals(to: Ingredient) -> Bool {
        return self.name == to.name
    }
}
