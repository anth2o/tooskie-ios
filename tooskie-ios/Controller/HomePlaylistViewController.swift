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
    private var playlistToStart: Playlist!
    
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
            self.playlistToStart = playlist
            performSegue(withIdentifier: "StartPlaylist", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != nil && segue.identifier == "StartPlaylist" {
            let destVC : PlaylistTableViewController = segue.destination as! PlaylistTableViewController
            destVC.playlist = self.playlistToStart!
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
    
    public func getPlaylists() {
        let session = GlobalVariables.serverConfig.getSession()
        let request = GlobalVariables.serverConfig.getRequest(path: "/api/tag/", method: "GET")
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            DispatchQueue.main.async {
                if let error = responseError {
                    print(error.localizedDescription)
                } else if let jsonData = responseData {
                    let decoder = JSONDecoder()
                    do {
                        let playlists = try decoder.decode([Playlist].self, from: jsonData)
                        self.playlists = playlists
                        self._collectionView.reloadData()
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
