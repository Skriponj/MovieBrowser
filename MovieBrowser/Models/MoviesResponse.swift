//
//  MoviesResponse.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 30.09.2020.
//

import Foundation

struct MoviesResponse: Decodable {
    
    var page: Int
    var totalPages: Int
    var movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case movies = "results"
    }
}
