//
//  HomePlaylistViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 05/02/2019.
//  Copyright © 2019 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class HomePlaylistViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    private var playlists = [Playlist]()
    
    @IBOutlet weak var _collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _collectionView.setBorder()
        getPlaylists()
        _collectionView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(startPlaylist), name: Notification.Name.startPlaylist, object: nil)
    }
    
    @objc
    func startPlaylist(notification:NSNotification){
        if let data = notification.userInfo as? [String: Any]
        {
            let playlist = data["playlist"] as! Playlist
            print(playlist.name!)
        }
    }    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playlistCollectionViewCell", for: indexPath) as! PlaylistCollectionViewCell
        let playlist = playlists[indexPath.row]
        cell.setPlaylist(playlist: playlist)
        return cell
    }
    
    private func getPlaylists() {
        let recipe_1 = Recipe(name: "Test de poulet")
        let recipe_2 = Recipe(name: "Test de fromage")
        let playlist_1 = Playlist(picture: "https://pbs.twimg.com/profile_images/701739690374729729/p3wuB1i4_400x400.png")
        playlist_1.name = "poulet"
        playlist_1.recipes = [recipe_1, recipe_2]
        let playlist_2 = Playlist(picture: "https://squaredwp.blob.core.windows.net/webmedia/2016/05/SearchSquared-240x240.png")
        playlist_2.name = "fromage"
        playlist_2.recipes = [recipe_1]
        playlists = [playlist_1, playlist_2]
    }
}
