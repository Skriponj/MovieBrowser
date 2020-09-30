//
//  GetMovieListRequest.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 30.09.2020.
//

import Foundation
import Alamofire

struct GetMovieListParameters {
    let apiKey: String
    let page: Int
}

struct GetMovieListRequest {
    let parameters: GetMovieListParameters
    let environment = NetworkEnvironment()
    
    var urlRequest: URLRequest? {
        var urlComponents = URLComponents(string: environment.getUrlPathFor(.movieList))
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: parameters.apiKey),
                                     URLQueryItem(name: "page", value: "\(parameters.page)")]
        guard let url = urlComponents?.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = Alamofire.HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
