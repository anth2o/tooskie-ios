//
//  UIView.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 26/10/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

extension UIView {
    public func setBorder() {
        let color = UIColor.darkGray.cgColor
        self.layer.borderWidth = 1
        self.layer.borderColor = color
        self.layer.cornerRadius = 8.0
        self.layer.shadowColor = color
        self.layer.shadowOpacity = 10
        self.layer.shadowRadius = 10
        self.clipsToBounds = true

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
