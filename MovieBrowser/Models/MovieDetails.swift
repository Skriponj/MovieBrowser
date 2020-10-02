//
//  MovieDetails.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 01.10.2020.
//

import Foundation

class MovieDetails: Decodable, NSCoding {
    
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
    
    init(id: Int, runtime: Int, genres: [Genre], trailerResponse: TrailerResponse) {
        self.id = id
        self.runtime = runtime
        self.genres = genres
        self.trailerResponse = trailerResponse
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(runtime, forKey: "id")
        coder.encode(genres as NSObject, forKey: "id")
        coder.encode(trailerResponse.videos as NSObject, forKey: "id")
    }
    
    required init?(coder: NSCoder) {
        id = coder.decodeObject(forKey: "id") as! Int
        runtime = coder.decodeObject(forKey: "runtime") as! Int
        genres = coder.decodeObject(forKey: "genres") as! [Genre]
        let trailers = coder.decodeObject(forKey: "trailers") as! [Trailer]
        trailerResponse = TrailerResponse(videos: trailers)
    }
}
