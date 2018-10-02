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
    @IBOutlet weak var ingredientPicture: UIImageView!
    @IBAction func discardIngredient(_ sender: Any) {
        if self.viewController != nil && self.ingredient != nil {
            self.viewController!.removeIngredient(ingredient: self.ingredient!)
        }
    }
    
    func configure(ingredient: Ingredient, viewController: ViewController) {
        self.ingredient = ingredient
        self.viewController = viewController
        self.ingredientName.text = ingredient.getName()
        if let pictureString = ingredient.getPictureString() {
            let url = URL(string: pictureString)
            let data = try? Data(contentsOf: url!)
            self.ingredientPicture.image = UIImage(data: data!)
        }
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
