//
//  CancelPosterDownloadUseCase.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 01.10.2020.
//

import Foundation

protocol CancelPosterDownloadUseCase {
    func cancelDownload(for key: String)
}

class AppCancelPosterDownloadUseCase: CancelPosterDownloadUseCase {
    
    let moviePosterGateway: MoviePosterGateway
    
    init(moviePosterGateway: MoviePosterGateway) {
        self.moviePosterGateway = moviePosterGateway
    }
    
    func cancelDownload(for key: String) {
        moviePosterGateway.cancelDownload(for: key)
    }
}
