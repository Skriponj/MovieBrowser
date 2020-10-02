//
//  CoreDataStorage.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 02.10.2020.
//

import Foundation
import CoreData

class CoreDataStorage: Database {
    
    let context: NSManagedObjectContext
    let coreDataStack: CoreDataStack
    
    init() {
        coreDataStack = AppCoreDataStack.shared
        context = coreDataStack.managedContext
    }
    
    func fetchAllMovies(completion: ([Movie]) -> Void) {
        let request = NSFetchRequest<CoreDataMovie>(entityName: CoreDataMovie.description())
        do {
            let result = try context.fetch(request).map({ $0.movie })
            completion(result)
        } catch let error {
            print("Local storage fetch failed -> \(error.localizedDescription)")
            completion([])
        }
    }
    
    func addFavoritMovie(_ movie: Movie, completion: (Movie?) -> Void) {
        fetchAllMovies { (movies) in
            if movies.contains(where: { $0 == movie }) {
                completion(movie)
                return
            }
            
            let entityName = CoreDataMovie.description()
            
            guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
                completion(nil)
                return
            }
            
            let record = CoreDataMovie(entity: entity, insertInto: context)
            record.setup(with: movie)
            if let details = detailsEntityForMovie(movie) {
                record.updateWithDetails(details)
            }
            
            coreDataStack.saveContext()
        }
    }
    
    private func detailsEntityForMovie(_ movie: Movie) -> CoreDataMovieDetails? {
        guard let details = movie.details else { return nil }
        let entityName = CoreDataMovieDetails.description()
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            return nil
        }
        
        let record = CoreDataMovieDetails(entity: entity, insertInto: context)
        record.setupWithDetails(details)
        return record
    }
    
    func saveCurrentState() {
        coreDataStack.saveContext()
    }
}
