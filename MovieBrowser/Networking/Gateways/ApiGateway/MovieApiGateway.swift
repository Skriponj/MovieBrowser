//
//  MovieApiGateway.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 29.09.2020.
//

import Foundation

protocol MovieApiGateway: AnyApiGateway {
    typealias GetMovieListCompletion = (_ movieList: Result<MoviesResponse, ApiError>) -> Void
    
    func getMovieList(page: Int, completion: @escaping GetMovieListCompletion)
}

class AppMovieApiGateway: MovieApiGateway {
    
    var apiClient: ApiClient
    
    required init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func getMovieList(page: Int, completion: @escaping GetMovieListCompletion) {
        let params = GetMovieListParameters(apiKey: apiClient.apiKey, page: page)
        let requestContainer = GetMovieListRequest(parameters: params)
        guard let request = requestContainer.urlRequest else {
            completion(.failure(.wrongRequest))
            return
        }
        apiClient.execute(request: request, completion: completion)
    }
}
