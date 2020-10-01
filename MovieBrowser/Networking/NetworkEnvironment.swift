//
//  NetworkEnvironment.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 29.09.2020.
//

import Foundation

class NetworkEnvironment {
    
    enum EndPoint {
        case movieDetails(_ movieId: Int)
        case getMoviePoster(_ path: String)
        case movieList
        case trailer(key: String)
        
        private var baseUrlPath: String {
            return "https://api.themoviedb.org/"
        }
        
        private var moviePosterBasePath: String {
            return "https://image.tmdb.org/t/p/w500"
        }
        
        private var trailerBasePath: String {
            return "https://www.youtube.com/watch?v="
        }
        
        var path: String {
            switch self {
            case .movieDetails(let movieId):
                return baseUrlPath.appending("3/movie/\(movieId)")
            case .movieList:
                return baseUrlPath.appending("4/list/1")
            case .getMoviePoster(let path):
                return moviePosterBasePath.appending(path)
            case .trailer(let key):
                return trailerBasePath.appending(key)
            }
        }
    }
    
    func getUrlPathFor(_ endpointType: EndPoint) -> String {
        return endpointType.path
    }
}
