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
    private var namePlural: String?
    private var complement: String?
    private var complementPlural: String?
    private var unit: String?
    private var unitPlural: String?
    private var quantity: Float?
    private var picture: String?
    public var permaname: String? {
        if let slug = self.name.convertedToSlug(){
            return slug
        }
        return nil
    }
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
    
    init(name: String, id: Int, picture: String) {
        self.name = name
        self.id = id
        self.picture = picture
    }
    
    public func equals(to: Ingredient) -> Bool {
        return self.name == to.name
    }
    
    public func getName() -> String {
        return self.name
    }
    
    public func getPictureString() -> String? {
        if let picture = self.picture {
            return picture
        }
        return nil
    }
    
    public func setPicture(picture: String) {
        self.picture = picture
    }
}

