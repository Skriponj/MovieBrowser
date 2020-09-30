//
//  NetworkEnvironment.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 29.09.2020.
//

import Foundation

class NetworkEnvironment {
    
    enum ApiVersion: Int {
        case movieDetails = 3
        case movieList = 4
    }
    
    private var baseUrlPath: String {
        return "https://api.themoviedb.org/"
    }
    
    func getUrlPathFor(_ apiVersion: ApiVersion) -> String {
        return baseUrlPath.appending("\(apiVersion.rawValue)")
    }
}
