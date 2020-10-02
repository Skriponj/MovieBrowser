//
//  Scene+ViewController.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 29.09.2020.
//

import UIKit

extension Scene {
    func viewController() -> UIViewController {
        switch self {
        case .movieDetails(let movie):
            let configurator = AppMovieDetailsConfigurator(movie: movie)
            let controller = MovieDetailsViewController.fromStoryboard()
            controller.configurator = configurator
            
            return controller
            
        case .movieList(let isFavoriteList):
            let configurator = AppMovieListConfigurator(withConfigForFavoriteList: isFavoriteList)
            let controller = MovieListViewController.fromStoryboard()
            controller.configurator = configurator
            
            return controller
        }
    }
}
