//
//  Movie.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 29.09.2020.
//

import Foundation

struct Movie: Decodable {
    var id: Int
    var title: String
    var poster: String
    var vote: Float
    var overview: String
    var releaseDateDescription: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "original_title"
        case poster = "poster_path"
        case vote = "vote_average"
        case overview
        case releaseDateDescription = "release_date"
    }
}

extension Movie {
    var releseDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        return dateFormatter.date(from: releaseDateDescription)
    }
}
