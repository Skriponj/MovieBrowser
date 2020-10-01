//
//  MovieDetailsPresenter.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 01.10.2020.
//

import Foundation

protocol MovieDetailsView: class {
    func updateMoviePoster(_ imageData: Data?)
    func updateMovieInfo(movie: Movie)
    func loadTrailer(trailerKey: String)
    func showError(title: String?, message: String?)
}

protocol MovieDetailsPresenter {
    func viewDidLoad()
    func handlePlayAction()
}

class AppMovieDetailsPresenter: MovieDetailsPresenter {
    
    enum UseCase {
        case downloadPosterUseCase(DownloadMoviePosterUseCase)
        case getMovieDetailsUseCase(GetMovieDetailsUseCase)
    }
    
    private let view: MovieDetailsView
    private let movie: Movie
    private var downloadMoviePosterUseCase: DownloadMoviePosterUseCase?
    private var getMovieDetailsUseCase: GetMovieDetailsUseCase?
    
    init(view: MovieDetailsView, movie: Movie, useCases: [UseCase]) {
        self.view = view
        self.movie = movie
        useCases.forEach { (useCase) in
            switch useCase {
            case .downloadPosterUseCase(let useCase):
                downloadMoviePosterUseCase = useCase
            case .getMovieDetailsUseCase(let useCase):
                getMovieDetailsUseCase = useCase
            }
        }
    }
    
    func viewDidLoad() {
        loadMovieDetails()
        loadMoviePoster()
    }
    
    func handlePlayAction() {
        guard let trailer = movie.details?.trailerResponse.videos.first else {
            view.showError(title: nil, message: "No available trailers provided")
            return
        }
        view.loadTrailer(trailerKey: trailer.key)
    }
}

private extension AppMovieDetailsPresenter {
    func loadMoviePoster() {
        let path = movie.posterPath
        let cacheKey = ImageCacheKey(value: movie.id)
        
        downloadMoviePosterUseCase?.downloadPoster(path: path, cacheKey: cacheKey.key) {
            [weak self] (result) in
            
            switch result {
            case .success(let imageData):
                DispatchQueue.main.async {
                    self?.view.updateMoviePoster(imageData)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.view.updateMoviePoster(nil)
                }
            }
        }
    }
    
    func loadMovieDetails() {
        getMovieDetailsUseCase?.getMovieDetails(movieId: movie.id, completion: { [weak self] (result) in
            
            switch result {
            case .success(let details):
                self?.movie.details = details
                self?.updateMovieInfo()
            case .failure(_):
                self?.updateMovieInfo()
            }
        })
    }
    
    func updateMovieInfo() {
        view.updateMovieInfo(movie: movie)
    }
}
