//
//  CoreDataManager.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/20/22.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MoviesManagedModel")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Could not load persistent store with error: \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    //MARK: - Lifecycle
    
    private init() { }
    
    //MARK: - Internal methods
    
    func saveMovies(_ movies: [Movie]) {
        let _ = movies.map {
            let managedMovie = MovieManagedObject(context: managedObjectContext)
            managedMovie.id = $0.id
            managedMovie.title = $0.title
            managedMovie.rank = $0.rank
            managedMovie.imageUrl = $0.imageUrl
        }
        
        saveContext()
    }
    
    func loadMovies() -> [Movie]? {
        let request: NSFetchRequest<MovieManagedObject> = MovieManagedObject.fetchRequest()
        
        var result: [Movie]?
        
        do {
            let managedMovies = try managedObjectContext.fetch(request)
            
            result = managedMovies.map {
                Movie(id: $0.id!, title: $0.title!, rank: $0.rank!, imageUrl: $0.imageUrl!)
            }
        } catch {
#if DEBUG
            print("Error fetching movies: \(error)")
#endif
        }
        
        return result
    }
    
    //MARK: - Private methods
    
    private func saveContext () {
        clearStorage()
        
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
#if DEBUG
                print("Coldn't save managed context with error: \(nserror), \(nserror.userInfo)")
#endif
            }
        }
    }
    
    private func clearStorage() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: MovieManagedObject.self))
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext.execute(batchDeleteRequest)
        } catch let error as NSError {
#if DEBUG
            print("Clear storage erro: \(error)")
#endif
        }
    }
}
