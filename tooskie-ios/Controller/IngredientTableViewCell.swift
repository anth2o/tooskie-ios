//
//  IngredientTableViewCell.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 29/09/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {
    var ingredient: Ingredient?
    var viewController: ViewController?
    
    @IBOutlet weak var ingredientName: UILabel!
    @IBAction func discardIngredient(_ sender: Any) {
        if self.viewController != nil && self.ingredient != nil {
            self.viewController!.removeIngredient(ingredient: self.ingredient!)
        }
    }
    
    init(ingredient: Ingredient, pantry: Pantry, viewController: ViewController){
        self.ingredient = ingredient
        self.viewController = viewController
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
