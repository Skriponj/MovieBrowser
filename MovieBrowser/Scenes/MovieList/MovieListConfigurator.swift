//
//  MovieListConfigurator.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 29.09.2020.
//

import UIKit

protocol MovieListConfigurator {
    func configure(movieListViewController: MovieListViewController)
}

class AppMovieListConfigurator: MovieListConfigurator {
    
    func configure(movieListViewController: MovieListViewController) {
        let apiClient = AppApiClient()
        let movieApiGateway = AppMovieApiGateway(apiClient: apiClient)
        let moviePosterGateway = AppMoviePosterGateway()
        let getMovieListUseCase = AppGetMovieUseCase(movieApiGateway: movieApiGateway)
        let downloadMoviePosterUseCase = AppDownloadMoviePosterUseCase(moviePosterGateway: moviePosterGateway)
        let cancelPosterDownloadUseCase = AppCancelPosterDownloadUseCase(moviePosterGateway: moviePosterGateway)
        
        let useCases: [AppMovieListPresenter.UseCase] = [.cancelPosterDownload(cancelPosterDownloadUseCase),
                                                         .downloadPosterUseCase(downloadMoviePosterUseCase),
                                                         .getMovieListUseCase(getMovieListUseCase)]
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let movieListPresenter = AppMovieListPresenter(view: movieListViewController,
                                                       useCases: useCases,
                                                       sceneCoordinator: appDelegate?.sceneCoordinator)
        
        movieListViewController.presenter = movieListPresenter
    }
}
