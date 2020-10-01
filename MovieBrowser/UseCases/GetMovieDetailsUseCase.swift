//
//  GetMovieDetailsUseCase.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 01.10.2020.
//

import Foundation

protocol GetMovieDetailsUseCase {
    typealias GetMovieDetailsCompletion = (_ movieList: Result<MovieDetails, ApiError>) -> Void
    
    func getMovieDetails(movieId: Int, completion: @escaping GetMovieDetailsCompletion)
}

class AppGetMovieDetailsUseCase: GetMovieDetailsUseCase {
    
    let movieApiGateway: MovieApiGateway
    
    init(movieApiGateway: MovieApiGateway) {
        self.movieApiGateway = movieApiGateway
    }
    
    func getMovieDetails(movieId: Int, completion: @escaping GetMovieDetailsCompletion) {
        movieApiGateway.getMovieDetails(movieId: movieId, completion: completion)
    }
}
