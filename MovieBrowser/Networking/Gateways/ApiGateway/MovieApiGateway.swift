//
//  MovieApiGateway.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 29.09.2020.
//

import Foundation

protocol MovieApiGateway: AnyApiGateway {
    typealias GetMovieListCompletion = (_ movieList: Result<MoviesResponse, ApiError>) -> Void
    typealias GetMovieDetailsCompletion = (_ movieList: Result<MovieDetails, ApiError>) -> Void
    
    func getMovieList(page: Int, completion: @escaping GetMovieListCompletion)
    func getMovieDetails(movieId: Int, completion: @escaping GetMovieDetailsCompletion)
}

class AppMovieApiGateway: MovieApiGateway {
    
    var apiClient: ApiClient
    
    required init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func getMovieList(page: Int, completion: @escaping GetMovieListCompletion) {
        let params = GetMovieListParameters(apiKey: apiClient.apiKey, page: page)
        let requestContainer = GetMovieListRequest(parameters: params)
        processRequest(requestContainer.urlRequest, completion: completion)
    }
    
    func getMovieDetails(movieId: Int, completion: @escaping GetMovieDetailsCompletion) {
        let params = GetMovieDetailsParameters(apiKey: apiClient.apiKey, movieId: movieId)
        let requestContainer = GetMovieDetailsRequest(parameters: params)
        processRequest(requestContainer.urlRequest, completion: completion)
    }
    
    private func processRequest<T: Decodable>(_ request: URLRequest?, completion: @escaping (_ result: Result<T, ApiError>) -> Void) {
        guard let request = request else {
            completion(.failure(.wrongRequest))
            return
        }
        apiClient.execute(request: request) { (result) in
            switch result {
            case .success(let data):
                guard let objData = data else {
                    completion(.failure(.wrongRequest))
                    return
                }
                do {
                    let model = try JSONDecoder().decode(T.self, from: objData)
                    completion(.success(model))
                } catch let error {
                    completion(.failure(ApiError(message: error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
