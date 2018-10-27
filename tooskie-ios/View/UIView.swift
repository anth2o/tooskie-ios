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
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
    }
}
