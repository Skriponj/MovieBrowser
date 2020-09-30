//
//  MovieListPresenter.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 29.09.2020.
//

import Foundation

protocol MovieListView: class {
    
}

protocol MovieListPresenter {
    func viewDidLoad()
    func getMovieList()
    func loadNextPage()
}

class AppMovieListPresenter: MovieListPresenter {
    private weak var view: MovieListView?
    private var getMovieListUseCase: GetMovieUseCase
    private var currentPage: Int = 1
    
    private var moviesResponse: MoviesResponse?
    
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
}

private extension AppMovieListPresenter {
    func handleSuccessApiResponse(_ movieResponse: MoviesResponse) {
        
    }
    
    func handleApiError(_ error: ApiError) {
        
    }
}
