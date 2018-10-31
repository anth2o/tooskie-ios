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

    enum Config {
        case local, dev
    }
    
    var config: Config = .local
    
    var host = "localhost"
    var port = 80
    
    init(){
        switch self.config {
        case .local:
            break
        case .dev:
            host = "ec2-52-47-163-208.eu-west-3.compute.amazonaws.com"
            port = 8000
        }
    }
    
    public func getUrlScheme() -> String {
        return self.scheme
    }
    
    public func getUrlHost() -> String {
        return self.host
    
    }
    
    public func getRequest(path: String, method: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        urlComponents.host = self.host
        urlComponents.port = self.port
        urlComponents.path = path
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        var request = URLRequest(url: url)
        request.httpMethod = method
        return request
    }
    
    public func getSession() -> URLSession {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session
    }
    
    public func encodeDataForPost(post: PostPantry, request: URLRequest) -> URLRequest {
        var newRequest = request
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        newRequest.allHTTPHeaderFields = headers
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(post)
            newRequest.httpBody = jsonData
            print("jsonData: ", String(data: newRequest.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            print(error)
        }
        return newRequest
    }
}
