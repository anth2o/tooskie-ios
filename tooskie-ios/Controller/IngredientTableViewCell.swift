//
//  IngredientTableViewCell.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 29/09/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var ingredientName: UILabel!
    var ingredient: Ingredient?
//    @IBOutlet weak var ingredientPicture: UIImageView!
//    @IBAction func ingredientButton(_ sender: Any) {
//    }
    //    @IBOutlet weak var ingredientButtonDisplay: UIButton!
    
    init(ingredient: Ingredient){
        self.ingredient = ingredient
//        if let picture = self.ingredient.picture {
//            self.ingredientPicture.te = picture
//        }
        super.init(style: .default, reuseIdentifier: nil)
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
