//
//  RecipeTableViewCell.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 06/02/2019.
//  Copyright © 2019 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    private var recipe: Recipe!
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    public func setRecipe(recipe: Recipe){
        self.recipe = recipe
        if let pictureData = recipe.getPictureData() {
            self.picture.image = UIImage(data: pictureData)
        }
        self.title.text = recipe.name
    }

}
