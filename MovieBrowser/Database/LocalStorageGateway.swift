//
//  LocalStorageGateway.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 02.10.2020.
//

import Foundation

protocol LocalStorageGateway {
    func addFavoriteMovie(_ movie: Movie, completion: (Movie?) -> Void)
    func fetchAllFavouriteMovies(completion: ([Movie]) -> Void)
}

class AppLocalStorageGateway: LocalStorageGateway {
    
    let database: Database
    
    init(database: Database) {
        self.database = database
    }
    
    func addFavoriteMovie(_ movie: Movie, completion: (Movie?) -> Void) {
        database.addFavoritMovie(movie, completion: completion)
    }
    
    func fetchAllFavouriteMovies(completion: ([Movie]) -> Void) {
        database.fetchAllMovies(completion: completion)
    }
}
