//
//  Playlist.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 05/02/2019.
//  Copyright © 2019 Antoine Hoorelbeke. All rights reserved.
//

import Foundation

class Playlist: Codable {
    public var name: String?
    public var picture: String?
    public var pictureData: Data?
    public var recipes = [Recipe]()
    
    init(picture: String){
        self.picture = picture
        _ = self.getPictureData()
    }
    
    public func getPictureData() -> Data?{
        if self.pictureData != nil {
            return self.pictureData
        }
        if let picture = self.picture {
            if let url = URL(string: picture) {
                let data = try? Data(contentsOf: url)
                if let data = data {
                    self.pictureData = data
                    return data
                }
            }
        }
        return nil
    }
}
