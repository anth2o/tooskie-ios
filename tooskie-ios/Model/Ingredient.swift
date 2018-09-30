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
    private var name: String
    private var picture: String?
    
    init(name: String) {
        self.name = name
    }
    
    convenience init() {
        self.init(name: "Poulet")
    }
    
    public func equals(to: Ingredient) -> Bool {
        return self.name == to.name
    }
    
    public func getName() -> String {
        return self.name
    }
}
