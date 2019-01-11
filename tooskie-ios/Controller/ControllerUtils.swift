//
//  UIViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 26/10/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit


struct GlobalVariables {
    static let tooskiePantry = Pantry(name: "Tooskie pantry")
    static let userPantry = Pantry(name: UIDevice.current.identifierForVendor!.uuidString)
    static let userShoppingList = Pantry(name: "Shopping list")
    static let serverConfig = ServerConfig(service: .django, config: .dev)
    static let logstashConfig = ServerConfig(service: .es, config: .local)
    static var recipes = [Recipe]()
    static var pantriesLoaded = false
    static let userName = "antoine"
    static var tabItemHeight = CGFloat(50)
}

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

extension UITextField {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
}


public func openUrl (urlString: String) {
    guard let url = URL(string: urlString) else {
        return //be safe
    }
    
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else {
        UIApplication.shared.openURL(url)
    }
}

extension Notification.Name {
    static let suggestionPressed = Notification.Name("suggestion-pressed")
    static let removeIngredient = Notification.Name("remove-ingredient")
    static let ingredientAdded = Notification.Name("ingredient-added")
}
