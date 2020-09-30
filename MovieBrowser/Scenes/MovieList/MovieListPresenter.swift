//
//  MovieListPresenter.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 29.09.2020.
//

import Foundation

protocol MovieListView: class {
    func showApiError(title: String?, message: String?)
    func refreshMovieList()
}

protocol MovieListPresenter {
    var movies: [Movie] { get }
    
    func viewDidLoad()
    func getMovieList()
    func loadNextPage()
    func configure(cell: MovieListCell, forItemAt indexPath: IndexPath)
}

class AppMovieListPresenter: MovieListPresenter {
    private weak var view: MovieListView?
    private var getMovieListUseCase: GetMovieUseCase
    private var currentPage: Int = 1
    
    private var moviesResponse: MoviesResponse?
    var movies: [Movie] {
        return moviesResponse?.movies ?? []
    }
    
    init(view: MovieListView, getMovieUseCase: GetMovieUseCase) {
        self.view = view
        self.getMovieListUseCase = getMovieUseCase
    }
    
    func viewDidLoad() {
        getMovieList()
    }
    
    func loadNextPage() {
        guard let moviesResponse = self.moviesResponse,
              currentPage < moviesResponse.totalPages else {
            return
        }
        currentPage += 1
        getMovieList()
    }
    
    func getMovieList() {
        getMovieListUseCase.getMovieList(page: currentPage) { [weak self] (result) in
            switch result {
            case .success(let movieResponse):
                self?.handleSuccessApiResponse(movieResponse)
            case .failure(let error):
                self?.handleApiError(error)
            }
        }
    }
    
    func configure(cell: MovieListCell, forItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        cell.titleLabel.text = movie.title
        cell.ratingLabel.text = "\(movie.vote)"
        cell.releaseDateLabel.text = movie.releaseDateDescription
    }
}

private extension AppMovieListPresenter {
    func handleSuccessApiResponse(_ movieResponse: MoviesResponse) {
        self.moviesResponse = movieResponse
        view?.refreshMovieList()
    }
    
    func handleApiError(_ error: ApiError) {
        view?.showApiError(title: "Error", message: error.message)
    }
}
