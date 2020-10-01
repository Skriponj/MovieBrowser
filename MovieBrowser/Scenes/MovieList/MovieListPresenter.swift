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
    func getMoviePosterForItemAt(indexPath: IndexPath, completion: @escaping (Data?) -> Void)
    func cancelDownloadPosterImageForItemAt(indexPath: IndexPath)
}

class AppMovieListPresenter: MovieListPresenter {
    
    enum UseCase {
        case downloadPosterUseCase(DownloadMoviePosterUseCase)
        case cancelPosterDownload(CancelPosterDownloadUseCase)
        case getMovieListUseCase(GetMovieUseCase)
    }
    
    private weak var view: MovieListView?
    private var getMovieListUseCase: GetMovieUseCase?
    private var downloadMoviePosterUseCase: DownloadMoviePosterUseCase?
    private var cancelDownloadPosterUseCase: CancelPosterDownloadUseCase?
    private var currentPage: Int = 1
    
    private var moviesResponse: MoviesResponse?
    var movies: [Movie] {
        return moviesResponse?.movies ?? []
    }
    
    init(view: MovieListView, useCases: [UseCase]) {
        self.view = view
        
        useCases.forEach { (useCase) in
            switch useCase {
            case .cancelPosterDownload(let useCase):
                cancelDownloadPosterUseCase = useCase
            case .downloadPosterUseCase(let useCase):
                downloadMoviePosterUseCase = useCase
            case .getMovieListUseCase(let useCase):
                getMovieListUseCase = useCase
            }
        }
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
        getMovieListUseCase?.getMovieList(page: currentPage) { [weak self] (result) in
            switch result {
            case .success(let movieResponse):
                self?.handleSuccessApiResponse(movieResponse)
            case .failure(let error):
                self?.handleApiError(error)
            }
        }
    }
    
    func getMoviePosterForItemAt(indexPath: IndexPath, completion: @escaping (Data?) -> Void) {
        let movie = movies[indexPath.item]
        let path = movie.posterPath
        let cacheKey = ImageCacheKey(value: movie.id)
        
        downloadMoviePosterUseCase?.downloadPoster(path: path, cacheKey: cacheKey.key) {
             (result) in
            
            switch result {
            case .success(let imageData):
                DispatchQueue.main.async {
                    completion(imageData)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func cancelDownloadPosterImageForItemAt(indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        let cacheKey = ImageCacheKey(value: movie.id)
        cancelDownloadPosterUseCase?.cancelDownload(for: cacheKey.key)
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
