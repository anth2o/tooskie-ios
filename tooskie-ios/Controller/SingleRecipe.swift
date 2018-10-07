//
//  SingleRecipe.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 07/10/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class SingleRecipe: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet private var label: UILabel!
    @IBOutlet private var icon: UIImageView!
    private var recipe: Recipe?
    
    public func setRecipe(recipe: Recipe) {
        self.recipe = recipe
        self.label.text = recipe.name
        if let pictureString = recipe.picture{
            let url = URL(string: pictureString)
            let data = try? Data(contentsOf: url!)
            self.icon.image = UIImage(data: data!)
        }
    }
}
