//
//  TrailerResponse.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 01.10.2020.
//

import Foundation

struct TrailerResponse: Decodable {
    var videos: [Trailer]
    
    enum CodingKeys: String, CodingKey {
        case videos = "results"
    }
}
