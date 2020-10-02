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
    func addItemsForNextPageAt(indexPaths: [IndexPath])
}

protocol MovieListPresenter {
    var movies: [Movie] { get }
    
    func viewDidLoad()
    func viewWillAppear()
    func getMovieList()
    func loadNextPage()
    func getMoviePosterForItemAt(indexPath: IndexPath, completion: @escaping (Data?) -> Void)
    func cancelDownloadPosterImageForItemAt(indexPath: IndexPath)
    func didSelectItemAt(indexPath: IndexPath)
    func loadNextPageIfNeeded(lastItemIndex: Int)
}

class AppMovieListPresenter: MovieListPresenter {
    
    enum UseCase {
        case downloadPosterUseCase(DownloadMoviePosterUseCase)
        case cancelPosterDownload(CancelPosterDownloadUseCase)
        case getMovieListUseCase(GetMovieUseCase)
        case fetchFavoriteMoviesUseCase(FetchFavoriteMoviesUseCase)
    }
    
    private weak var view: MovieListView?
    private var getMovieListUseCase: GetMovieUseCase?
    private var downloadMoviePosterUseCase: DownloadMoviePosterUseCase?
    private var cancelDownloadPosterUseCase: CancelPosterDownloadUseCase?
    private var fetchFavoriteMoviesUseCase: FetchFavoriteMoviesUseCase?
    private var sceneCoordinator: SceneCoordinator?
    private var currentPage: Int = 1
    private let isFaforiteList: Bool
    
    private var moviesResponse: MoviesResponse?
    private var isNextPageRequest: Bool = false
    var movies: [Movie] = []
    
    init(view: MovieListView, useCases: [UseCase], sceneCoordinator: SceneCoordinator?, isFaforiteList: Bool = false) {
        self.view = view
        self.sceneCoordinator = sceneCoordinator
        self.isFaforiteList = isFaforiteList
        
        useCases.forEach { (useCase) in
            switch useCase {
            case .cancelPosterDownload(let useCase):
                cancelDownloadPosterUseCase = useCase
            case .downloadPosterUseCase(let useCase):
                downloadMoviePosterUseCase = useCase
            case .getMovieListUseCase(let useCase):
                getMovieListUseCase = useCase
            case .fetchFavoriteMoviesUseCase(let useCase):
                fetchFavoriteMoviesUseCase = useCase
            }
        }
    }
    
    func viewDidLoad() {
        getMovieList()
    }
    
    func viewWillAppear() {
        if isFaforiteList {        
            getMovieList()
        }
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
        if isFaforiteList {
            loadFavoriteMoviesFromDB()
            return
        }
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
                completion(imageData)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func cancelDownloadPosterImageForItemAt(indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        let cacheKey = ImageCacheKey(value: movie.id)
        cancelDownloadPosterUseCase?.cancelDownload(for: cacheKey.key)
    }
    
    func didSelectItemAt(indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        sceneCoordinator?.transition(to: .movieDetails(movie), transitionType: .push)
    }
    
    func loadNextPageIfNeeded(lastItemIndex: Int) {
        if lastItemIndex == movies.count - 1 {
            isNextPageRequest = true
            loadNextPage()
        }
    }
}

private extension AppMovieListPresenter {
    func handleSuccessApiResponse(_ movieResponse: MoviesResponse) {
        self.moviesResponse = movieResponse
        let moviesCount = movies.count
        movies.append(contentsOf: movieResponse.movies)
        if isNextPageRequest {
            let newItems = (moviesCount..<movies.count).map { IndexPath(item: $0, section: 0) }
            view?.addItemsForNextPageAt(indexPaths: newItems)
            isNextPageRequest = false
            return
        }
        view?.refreshMovieList()
    }
    
    func handleApiError(_ error: ApiError) {
        view?.showApiError(title: "Error", message: error.message)
    }
    
    func loadFavoriteMoviesFromDB() {
        fetchFavoriteMoviesUseCase?.fetchAllFavouriteMovies(completion: { (movies) in
            print(movies)
            self.moviesResponse = MoviesResponse(page: 1, totalPages: 1, movies: movies)
            self.movies = movies
            self.view?.refreshMovieList()
        })
    }
}
