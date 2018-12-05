//
//  UIView.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 26/10/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

extension UIView {
    public func setBorder(color: CGColor = UIColor.darkGray.cgColor, withShadow: Bool = true, cornerRadius: CGFloat = 8.0, borderWidth: CGFloat = 1.0) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = color
        if cornerRadius > 0 {
            self.layer.cornerRadius = cornerRadius
        }
        if withShadow {
            self.layer.shadowColor = color
            self.layer.shadowOpacity = 10
            self.layer.shadowRadius = 10
        }
        self.clipsToBounds = true
    }
    
    public func removeBorder() {
        let color = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.layer.borderColor = color
    }
}

extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }
        
        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }
        
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0
        
        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

public let lightBlue = UIColor(red: 20, green: 120, blue: 246)
public let customGreen = UIColor(red: 60, green: 198, blue: 132)

