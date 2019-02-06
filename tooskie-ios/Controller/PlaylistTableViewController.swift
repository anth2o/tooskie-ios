//
//  PlaylistTableViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 06/02/2019.
//  Copyright © 2019 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class PlaylistTableViewController: UITableViewController {
    
    public var playlist: Playlist!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playlist.recipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeTableViewCell", for: indexPath) as! RecipeTableViewCell
        let recipe = self.playlist!.recipes[indexPath.row]
        cell.setRecipe(recipe: recipe)
        cell.selectionStyle = .none
        return cell
    }
}
