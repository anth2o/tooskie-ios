//
//  Ingredient.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 26/09/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import Foundation
import UIKit

class Ingredient: Codable {
    private var id: Int?
    private var name: String
    private var picture: String?
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
    
    public func equals(to: Ingredient) -> Bool {
        return self.name == to.name
    }
    
    public func getName() -> String {
        return self.name
    }
    
    public func setPicture(picture: String) {
        self.picture = picture
    }
}
