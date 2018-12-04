//
//  Utils.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 02/10/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import Foundation

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
    
    
    public func capitalize() -> String {
        return self.prefix(1).uppercased() + self.dropFirst()
    }
}

func round(_ num: Double, to places: Int) -> Double {
    let p = log10(abs(num))
    let f = pow(10, p.rounded() - Double(places) + 1)
    let rnum = (num / f).rounded() * f
    
    return rnum
}

func round(_ num: Float, to places: Int) -> Float {
    let p = log10(abs(num))
    let f = pow(10, p.rounded() - Float(places) + 1)
    let rnum = (num / f).rounded() * f
    
    return rnum
}

func round(_ num: Int, to places: Int) -> Int {
    let p = log10(abs(Double(num)))
    let f = pow(10, p.rounded() - Double(places) + 1)
    let rnum = (Double(num) / f).rounded() * f
    
    return Int(rnum)
}
