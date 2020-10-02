//
//  MovieDetailsConfigurator.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 01.10.2020.
//

import Foundation

protocol MovieDetailsConfigurator {
    func configure(movieListViewController: MovieDetailsViewController)
}

class AppMovieDetailsConfigurator: MovieDetailsConfigurator {
    
    let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func configure(movieListViewController: MovieDetailsViewController) {
        let apiClient = AppApiClient()
        let storageGateway = AppLocalStorageGateway(database: CoreDataStorage())
        let movieApiGateway = AppMovieApiGateway(apiClient: apiClient)
        let moviePosterGateway = AppMoviePosterGateway()
        let downloadMoviePosterUseCase = AppDownloadMoviePosterUseCase(moviePosterGateway: moviePosterGateway)
        let getMovieDetailsUseCase = AppGetMovieDetailsUseCase(movieApiGateway: movieApiGateway)
        let addFavoriteMovieUseCase = AppAddFavoriteMovieUseCase(storageGateway: storageGateway)
        
        let useCases: [AppMovieDetailsPresenter.UseCase] = [.downloadPosterUseCase(downloadMoviePosterUseCase),
                                                            .getMovieDetailsUseCase(getMovieDetailsUseCase),
                                                            .addFavoriteMovieUseCase(addFavoriteMovieUseCase)]
        
        let movieDetailsPresenter = AppMovieDetailsPresenter(view: movieListViewController,
                                                             movie: movie,
                                                             useCases: useCases)
        movieListViewController.presenter = movieDetailsPresenter
    }
}
