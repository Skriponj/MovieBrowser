//
//  Movie.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 29.09.2020.
//

import UIKit

struct Movie: Decodable {
    var id: Int
    var title: String
    var posterPath: String
    var vote: Float
    var overview: String
    var releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "original_title"
        case posterPath = "poster_path"
        case vote = "vote_average"
        case overview
        case releaseDate = "release_date"
    }
}

extension Movie {
    var releaseDateDescription: String? {
        let date = releaseDate.toDate()
        return date?.toString()
    }
}
