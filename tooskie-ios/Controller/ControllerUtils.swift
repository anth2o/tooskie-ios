//
//  UIViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 26/10/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

extension UIViewController {
    public func getPictureFromString (picture: String?) -> UIImage {
        if let pictureString = picture {
            let url = URL(string: pictureString)
            if url != nil {
                let data = try? Data(contentsOf: url!)
                if let data = data {
                    return UIImage(data: data)!
                }
            }
        }
        return UIImage(named: "NoNetwork")!
    }
}

struct GlobalVariables {
    static let tooskiePantry = Pantry(name: "Tooskie pantry")
    static let userPantry = Pantry(name: "iOS")
    static let serverConfig = ServerConfig()
    static var recipes = [Recipe]()
}
