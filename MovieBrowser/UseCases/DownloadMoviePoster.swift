//
//  DownloadMoviePoster.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 30.09.2020.
//

import UIKit

protocol DownloadMoviePosterUseCase {
    func downloadPoster(path: String, cacheKey: String, completion: @escaping (Result<Data?, Error>) -> Void)
}

class AppDownloadMoviePosterUseCase: DownloadMoviePosterUseCase {
    
    let moviePosterGateway: MoviePosterGateway
    
    init(moviePosterGateway: MoviePosterGateway) {
        self.moviePosterGateway = moviePosterGateway
    }
    
    func downloadPoster(path: String, cacheKey: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        DispatchQueue.global().async {
            self.moviePosterGateway.downloadImage(path: path, for: cacheKey, completion: completion)
        }
    }
}
