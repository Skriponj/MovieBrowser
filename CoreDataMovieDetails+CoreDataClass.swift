//
//  CoreDataMovieDetails+CoreDataClass.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 02.10.2020.
//
//

import Foundation
import CoreData

@objc(CoreDataMovieDetails)
public class CoreDataMovieDetails: NSManagedObject {

    var details: MovieDetails {
        let genres = self.genres as? [Genre]
        let trailers = self.trailers  as? [Trailer]

        return MovieDetails(id: Int(id),
                            runtime: Int(runtime),
                            genres: genres ?? [],
                            trailerResponse: TrailerResponse(videos: trailers ?? []))
    }
    
    func setupWithDetails(_ details: MovieDetails) {
        id = Int32(details.id)
        runtime = Int16(details.runtime)
        genres = details.genres as NSObject
        trailers = details.trailerResponse.videos as NSObject
    }
}
