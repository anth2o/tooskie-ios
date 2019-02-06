//
//  PlaylistCollectionViewCell.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 05/02/2019.
//  Copyright © 2019 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class PlaylistCollectionViewCell: UICollectionViewCell {
    
    private var playlist: Playlist!
    
    @IBOutlet var button: UIButton!
    
    @IBAction func startPlaylist(_ sender: Any) {
        NotificationCenter.default.post(name: .startPlaylist, object: self, userInfo: ["playlist": self.playlist])

    }

    public func setPlaylist(playlist: Playlist){
        self.playlist = playlist
        self.button.setImage(UIImage(data: playlist.getPictureData()!)!, for: .normal)
    }
}
