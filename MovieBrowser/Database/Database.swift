//
//  Database.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 02.10.2020.
//

import Foundation

protocol Database {
    func fetchAllMovies(completion: ([Movie]) -> Void)
    func addFavoritMovie(_ movie: Movie, completion: (Movie?) -> Void)
    func saveCurrentState()
}
