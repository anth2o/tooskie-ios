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
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playlistCollectionViewCell", for: indexPath) as! PlaylistCollectionViewCell
        let playlist = playlists[indexPath.row]
        cell.displayContent(image: UIImage(data: playlist.pictureData!)!)
        return cell
    }
    
    private func getPlaylists() {
        let playlist_1 = Playlist(picture: "https://pbs.twimg.com/profile_images/701739690374729729/p3wuB1i4_400x400.png")
        let playlist_2 = Playlist(picture: "https://squaredwp.blob.core.windows.net/webmedia/2016/05/SearchSquared-240x240.png")
        playlists = [playlist_1, playlist_2]
    }
}
