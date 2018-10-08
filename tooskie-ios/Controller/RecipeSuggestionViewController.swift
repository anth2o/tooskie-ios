//
//  RecipeSuggestionViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 07/10/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class RecipeSuggestionViewController: UIViewController {
    
    var pantryPermaname: String?
    var serverConfig = ServerConfig()
    var recipes = [Recipe]()

    @IBOutlet weak var recipeView: SingleRecipe!
    
    @IBAction func goBack(_ sender: Any) {
        performSegue(withIdentifier: "GoBack", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getRecipes()
        sleep(10)
        if self.recipes.count > 0 {
            self.recipeView!.setRecipe(recipe: self.recipes[0])
        }
    }
    
    public func getRecipes() {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.serverConfig.getUrlScheme()
        urlComponents.host = self.serverConfig.getUrlHost()
        if let permaname = self.pantryPermaname {
            urlComponents.path = "/recipe/" + permaname
            guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                DispatchQueue.main.async {
                    if let error = responseError {
                        print(error.localizedDescription)
                    } else if let jsonData = responseData {
                        let decoder = JSONDecoder()
                        do {
                            let recipes = try decoder.decode([Recipe].self, from: jsonData)
                            self.recipes = recipes
                        } catch {
                            print("Error")
                        }
                    } else {
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
        }
    }
}
