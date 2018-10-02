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

extension String {
    private static let slugSafeCharacters = CharacterSet(charactersIn: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-")
    
    public func convertedToSlug() -> String? {
        if let latin = self.applyingTransform(StringTransform("Any-Latin; Latin-ASCII; Lower;"), reverse: false) {
            let urlComponents = latin.components(separatedBy: String.slugSafeCharacters.inverted)
            let result = urlComponents.filter { $0 != "" }.joined(separator: "-")
            
            if result.count > 0 {
                return result
            }
        }
        
        return nil
    }
}
