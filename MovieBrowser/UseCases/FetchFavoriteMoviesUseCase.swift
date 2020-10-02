//
//  FetchFavoriteMoviesUseCase.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 02.10.2020.
//

import Foundation

protocol FetchFavoriteMoviesUseCase {
    func fetchAllFavouriteMovies(completion: ([Movie]) -> Void)
}

class AppFetchFavoriteMoviesUseCase: FetchFavoriteMoviesUseCase {
    
    let storageGateway: LocalStorageGateway
    
    init(storageGateway: LocalStorageGateway) {
        self.storageGateway = storageGateway
    }
    
    func fetchAllFavouriteMovies(completion: ([Movie]) -> Void) {
        storageGateway.fetchAllFavouriteMovies(completion: completion)
    }
}
