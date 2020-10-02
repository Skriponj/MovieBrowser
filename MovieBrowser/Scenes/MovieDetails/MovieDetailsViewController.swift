//
//  MovieDetailsViewController.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 01.10.2020.
//

import UIKit
import youtube_ios_player_helper
import SnapKit

class MovieDetailsViewController: UIViewController, MovieDetailsView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    
    var favoriteButton: UIBarButtonItem!
    var playerView: TrailerView!
    var configurator: MovieDetailsConfigurator!
    var presenter: MovieDetailsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView = TrailerView.fromNib()
        playerView.delegate = self
        setupUI()
        configurator.configure(movieListViewController: self)
        presenter.viewDidLoad()
    }
    
    @IBAction func playAction(_ sender: Any) {
        presenter.handlePlayAction()
    }
    
    @IBAction func addMovieToFavoriteList(_ sender: Any) {
        presenter.addMovieToFavoriteList()
    }
        
    func updateMovieInfo(movie: Movie) {
        hideLoadingView()
        
        titleLabel.text = movie.title
        releaseDateLabel.text = "Release date: \(movie.releaseDateDescription ?? "Undefined")"
        ratingLabel.text = "\(movie.vote)"
        overviewLabel.text = movie.overview
        
        if let details = movie.details {
            setupMovieDetails(details)
        }
    }
    
    func updateMoviePoster(_ imageData: Data?) {
        guard let data = imageData, let image = UIImage(data: data) else {
            return
        }
        posterImageView.image = image
    }
    
    func showError(title: String?, message: String?) {
        showAlert(title: title, message: message)
    }
    
    func loadTrailer(trailerKey: String) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        playerView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.playerView.alpha = 1
        } completion: { (_) in
            self.playerView.loadTrailerForKey(trailerKey)
        }
    }
}

private extension MovieDetailsViewController {
    
    private func setupUI() {
        ratingView.layer.cornerRadius = ratingView.bounds.height / 2
        ratingView.layer.masksToBounds = true
        
        playerView.isHidden = true
        playerView.alpha = 0
        playerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerView)
        playerView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
        
        favoriteButton = UIBarButtonItem(image: UIImage(named: "star_empty"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(addMovieToFavoriteList(_:)))
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    private func hideLoadingView() {
        UIView.animate(withDuration: 0.3) {
            self.loadingView.alpha = 0
        } completion: { _ in
            self.loadingView.isHidden = true
        }
    }
    
    private func setupMovieDetails(_ details: MovieDetails) {
        let genres = details.genres.map{ $0.name }.joined(separator: ", ")
        genresLabel.text = "Genres: \(genres) • \(details.runtime)m"
    }
}

extension MovieDetailsViewController: TrailerViewDelegate {
    func closeActionRequest() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        UIView.animate(withDuration: 0.3) {
            self.playerView.alpha = 0
        } completion: { _ in
            self.playerView.isHidden = true
        }
    }
}
