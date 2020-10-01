//
//  MovieDetails.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 01.10.2020.
//

import Foundation

struct MovieDetails: Decodable {
    var id: Int
    var runtime: Int
    var genres: [Genre]
    var trailerResponse: TrailerResponse
    
    enum CodingKeys: String, CodingKey {
        case id
        case runtime
        case genres
        case trailerResponse = "videos"
    }
}
