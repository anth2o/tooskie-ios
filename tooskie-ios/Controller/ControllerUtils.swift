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

extension UITableView {
    
    func scrollToBottom(){
        
        DispatchQueue.main.async {
            let inSection = self.numberOfSections - 1
            let row = self.numberOfRows(inSection: inSection) - 1
            if row > 0 {
                let indexPath = NSIndexPath(row: row, section: self.numberOfSections - 1)
                self.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func scrollToTop() {
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
}

struct GlobalVariables {
    static let tooskiePantry = Pantry(name: "Tooskie pantry")
    static let userPantry = Pantry(name: "iOS")
    static let serverConfig = ServerConfig()
    static var recipes = [Recipe]()
}
