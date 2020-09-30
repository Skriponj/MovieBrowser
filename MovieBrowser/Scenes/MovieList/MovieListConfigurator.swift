//
//  MovieListConfigurator.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 29.09.2020.
//

import Foundation

protocol MovieListConfigurator {
    func configure(movieListViewController: MovieListViewController)
}

class AppMovieListConfigurator: MovieListConfigurator {
    
    func configure(movieListViewController: MovieListViewController) {
        let apiClient = AppApiClient()
        let movieApiGateway = AppMovieApiGateway(apiClient: apiClient)
        let getMovieListUseCase = AppGetMovieUseCase(movieApiGateway: movieApiGateway)
        let movieListPresenter = AppMovieListPresenter(view: movieListViewController, getMovieUseCase: getMovieListUseCase)
        
        movieListViewController.presenter = movieListPresenter
    }
}
