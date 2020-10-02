//
//  AddFavoriteMovieUseCase.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 02.10.2020.
//

import Foundation

protocol AddFavoriteMovieUseCase {
    func addFavoriteMovie(_ movie: Movie, completion: (Movie?) -> Void)
}

class AppAddFavoriteMovieUseCase: AddFavoriteMovieUseCase {
    
    let storageGateway: LocalStorageGateway
    
    init(storageGateway: LocalStorageGateway) {
        self.storageGateway = storageGateway
    }
    
    func addFavoriteMovie(_ movie: Movie, completion: (Movie?) -> Void) {
        storageGateway.addFavoriteMovie(movie, completion: completion)
    }
}
