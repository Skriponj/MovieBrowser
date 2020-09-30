//
//  GetMovieList.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 30.09.2020.
//

import Foundation

protocol GetMovieUseCase {
    typealias GetMovieListCompletion = (_ movieList: Result<MoviesResponse, ApiError>) -> Void
    
    func getMovieList(page: Int, completion: @escaping GetMovieListCompletion)
}

class AppGetMovieUseCase: GetMovieUseCase {
    
    let movieApiGateway: MovieApiGateway
    
    init(movieApiGateway: MovieApiGateway) {
        self.movieApiGateway = movieApiGateway
    }
    
    func getMovieList(page: Int, completion: @escaping GetMovieListCompletion) {
        movieApiGateway.getMovieList(page: page, completion: completion)
    }
}
