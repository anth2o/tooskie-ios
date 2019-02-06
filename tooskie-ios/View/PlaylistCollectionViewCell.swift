//
//  PlaylistCollectionViewCell.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 05/02/2019.
//  Copyright © 2019 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class PlaylistCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var button: UIButton!
    
    func displayContent(image: UIImage){
        button.setImage(image, for: UIControl.State.normal)
    }
}
