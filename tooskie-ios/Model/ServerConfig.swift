//
//  ServerConfig.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 02/10/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import Foundation

class ServerConfig {
    var scheme = "http"
    var host = "localhost"
    
    public func getUrlScheme() -> String {
        return self.scheme
    }
    
    public func getUrlHost() -> String {
        return self.host
    }
}
