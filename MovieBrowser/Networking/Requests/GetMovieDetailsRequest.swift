//
//  GetMovieDetailsRequest.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 01.10.2020.
//

import Foundation
import Alamofire

struct GetMovieDetailsParameters {
    let apiKey: String
    let movieId: Int
}

struct GetMovieDetailsRequest {
    let parameters: GetMovieDetailsParameters
    let environment = NetworkEnvironment()
    
    var urlRequest: URLRequest? {
        var urlComponents = URLComponents(string: environment.getUrlPathFor(.movieDetails(parameters.movieId)))
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: parameters.apiKey),
                                     URLQueryItem(name: "append_to_response", value: "videos")]
        guard let url = urlComponents?.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = Alamofire.HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
