//
//  ActivityView.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 05/12/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class ActivityView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityLabel: UILabel!

    public func startAnimation(title: String) {
        self.isHidden = false
        self.activityIndicator.startAnimating()
        self.activityLabel.text = title
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    public func stopAnimation() {
        self.isHidden = true
        self.activityIndicator.stopAnimating()
    }
}
