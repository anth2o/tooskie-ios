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
    public var pictureData: Data?
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
    
    private func getQuantity(peopleNumber: Int?) -> Float?{
        if let quantity = self.quantity {
            if let number = peopleNumber {
                return Float(number) * quantity
            }
            return quantity
        }
        return nil
    }
    
    public func getDescription(peopleNumber: Int?) -> String{
        let realQuantity = self.getQuantity(peopleNumber: peopleNumber)
        var description = "- "
        if let quantity = realQuantity {
            description += String(quantity) + " "
        }
        if let unit = self.unit {
            if unit != "None" {
                description += unit.lowercased() + " de "
            }
        }
        description += name.lowercased()
        return description
    }
    
    public func getPictureData() -> Data?{
        if self.pictureData != nil {
            return self.pictureData
        }
        if let picture = self.picture {
            if let url = URL(string: picture) {
                let data = try? Data(contentsOf: url)
                if let data = data {
                    self.pictureData = data
                    return data
                }
            }
        }
        return nil
    }
}

