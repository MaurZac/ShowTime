//
//  FavoriteMovieRepositoryImpl.swift
//  ShowTime
//
//  Created by MaurZac on 22/07/24.
//

import CoreData
import Foundation
import Combine


protocol FavoriteMovieRepository {
    var favoritesPublisher: AnyPublisher<[Movie], Never> { get }
    func fetchFavorites() -> [Movie]
    func save(movie: Movie)
}

final class FavoriteMovieRepositoryImpl: FavoriteMovieRepository {
    
    private let coreDataManager: CoreDataManager
    private var favoritesSubject = CurrentValueSubject<[Movie], Never>([])
    
    var favoritesPublisher: AnyPublisher<[Movie], Never> {
        favoritesSubject.eraseToAnyPublisher()
    }
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        let initialFavorites = fetchFavorites()
        favoritesSubject.send(initialFavorites)
    }
    
    func fetchFavorites() -> [Movie] {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        
        do {
            let movieEntities = try coreDataManager.context.fetch(fetchRequest)
            let movies = movieEntities.map { Movie(entity: $0) }
            return movies
        } catch {
            print("Failed to fetch movies: \(error)")
            return []
        }
    }
    
    func save(movie: Movie) {
        let context = coreDataManager.context
        let movieEntity = MovieEntity(context: context)
        movieEntity.title = movie.title
        movieEntity.imageUrl = movie.posterPath
        
        do {
            try context.save()
            let updatedFavorites = fetchFavorites()
            favoritesSubject.send(updatedFavorites)
        } catch {
            print("Error al guardar la película: \(error)")
        }
    }
}
