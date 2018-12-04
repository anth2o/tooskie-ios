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
    public var picture: String?
    public var pictureData: Data?
    private var namePlural: String?
    private var complement: String?
    private var complementPlural: String?
    private var unit: String?
    private var unitPlural: String?
    private var linkingWord: String?
    private var linkingWordPlural: String?
    private var quantity: Float?
    public var permaname: String? {
        if let slug = self.name.convertedToSlug(){
            return slug
        }
        return nil
    }
    
    init(name: String){
        self.name = name
    }
    
    public func equals(to: Ingredient) -> Bool {
        if let permaname1 = self.name.convertedToSlug() {
            if let permaname2 = to.name.convertedToSlug() {
                if let namePlural = self.namePlural {
                    if let permanamePlural = self.namePlural?.convertedToSlug() {
                        return permanamePlural == permaname2 || permaname1 == permaname2
                    }
                    return to.name == namePlural
                }
                return permaname1 == permaname2
            }
        }
        return name == to.name
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
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        fmt.maximumSignificantDigits = 2
        var description = "- "
        var isPlural = false
        if realQuantity != nil {
            let quantity = Double(realQuantity!)
            var quantityString = fmt.string(for: quantity)!
            // if the quantity is an integer we remove the .0 at the end
            if Double(Int(quantity)) == quantity {
                quantityString = String(Int(quantity))
            }
            description += quantityString + " "
            if quantity >= 2.0 {
                isPlural = true
            }
        }
        var trueUnit: String?
        if isPlural {
            if self.unitPlural != nil {
                trueUnit = self.unitPlural!
            }
        }
        else {
            if self.unit != nil {
                trueUnit = self.unit!
            }
        }
        if let unit = trueUnit {
            if unit != "None" && unit != "" {
                if let linkingWord = self.linkingWord {
                    description += unit.lowercased() + " " +  linkingWord
                    if linkingWord.last! != "'" {
                        description += " "
                    }
                }
            }
        }
        if isPlural && self.namePlural != nil {
            description += namePlural!.lowercased()
        }
        else{
            description += name.lowercased()
        }
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

