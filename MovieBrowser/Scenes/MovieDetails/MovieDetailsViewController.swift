//
//  MovieDetailsViewController.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 01.10.2020.
//

import UIKit

class MovieDetailsViewController: UIViewController, MovieDetailsView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    
    var configurator: MovieDetailsConfigurator!
    var presenter: MovieDetailsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configurator.configure(movieListViewController: self)
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        ratingView.layer.cornerRadius = ratingView.bounds.height / 2
        ratingView.layer.masksToBounds = true
    }
    
    func updateMovieInfo(movie: Movie) {
        hideLoadingView()
        
        titleLabel.text = movie.title
        releaseDateLabel.text = "Release date: \(String(describing: movie.releaseDateDescription))"
        ratingLabel.text = "\(movie.vote)"
        overviewLabel.text = movie.overview
        
        if let details = movie.details {
            setupMovieDetails(details)
        }
    }
    
    private func setupMovieDetails(_ details: MovieDetails) {
        let genres = details.genres.map{ $0.name }.joined(separator: ", ")
        genresLabel.text = "Genres: \(genres)"
    }
    
    func updateMoviePoster(_ imageData: Data?) {
        guard let data = imageData, let image = UIImage(data: data) else {
            return
        }
        posterImageView.image = image
    }
    
    private func hideLoadingView() {
        UIView.animate(withDuration: 0.3) {
            self.loadingView.alpha = 0
        } completion: { _ in
            self.loadingView.isHidden = true
        }

    }
}
