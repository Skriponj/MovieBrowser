//
//  CoreDataMovie+CoreDataClass.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 02.10.2020.
//
//

import Foundation
import CoreData

@objc(CoreDataMovie)
public class CoreDataMovie: NSManagedObject {
    var movie: Movie {
        return Movie(id: Int(id),
                     title: title ?? "",
                     posterPath: posterPath ?? "",
                     vote: vote,
                     overview: overview ?? "",
                     releaseDate: releaseDate ?? "",
                     details: details?.details)
    }
    
    func setup(with movie: Movie) {
        id = Int32(movie.id)
        title = movie.title
        vote = movie.vote
        overview = movie.overview
        releaseDate = movie.releaseDate
    }
    
    func updateWithDetails(_ details: CoreDataMovieDetails) {
        self.details = details
    }
}
