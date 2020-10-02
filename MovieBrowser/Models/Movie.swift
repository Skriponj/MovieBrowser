//
//  Movie.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 29.09.2020.
//

import UIKit

class Movie: Decodable {
    var id: Int
    var title: String
    var posterPath: String
    var vote: Float
    var overview: String
    var releaseDate: String
    var details: MovieDetails?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "original_title"
        case posterPath = "poster_path"
        case vote = "vote_average"
        case overview
        case releaseDate = "release_date"
    }
    
    init(id: Int, title: String, posterPath: String, vote: Float, overview: String, releaseDate: String, details: MovieDetails?) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.vote = vote
        self.overview = overview
        self.releaseDate = releaseDate
        self.details = details
    }
}

extension Movie {
    var releaseDateDescription: String? {
        let date = releaseDate.toDate()
        return date?.toString()
    }
}

extension Movie: Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}
