//
//  WatchListViewModel.swift
//  ShowTime
//
//  Created by MaurZac on 22/07/24.
//

import Foundation
import Combine

final class WatchlistViewModel {
    
    @Published var movies: [Movie] = []
    
    private let favoriteMovieRepository: FavoriteMovieRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(favoriteMovieRepository: FavoriteMovieRepository) {
        self.favoriteMovieRepository = favoriteMovieRepository
        setupBindings()
    }
    
    private func setupBindings() {
        favoriteMovieRepository.favoritesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] allMovies in
                guard let self = self else { return }
                var seenTitles = Set<String>()
                self.movies = allMovies.filter { movie in
                    if seenTitles.contains(movie.title) {
                        return false
                    } else {
                        seenTitles.insert(movie.title)
                        return true
                    }
                }
            }
            .store(in: &cancellables)
    }
}
