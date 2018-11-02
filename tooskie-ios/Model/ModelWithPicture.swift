//
//  ModelWithPicture.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 02/11/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import Foundation

class ModelWithPicture: Codable {
    public var picture: String?
    public var pictureData: Data?
    
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
