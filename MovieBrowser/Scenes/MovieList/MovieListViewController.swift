//
//  MovieListViewController.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 29.09.2020.
//

import UIKit

class MovieListViewController: UIViewController, MovieListView {

    var configurator = AppMovieListConfigurator()
    var presenter: MovieListPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(movieListViewController: self)
        presenter.viewDidLoad()
    }
}
