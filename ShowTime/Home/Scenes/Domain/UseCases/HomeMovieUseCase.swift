//
//  HomeMovieUseCase.swift.swift
//  ShowTime
//
//  Created by MaurZac on 21/07/24.
//

import Combine
import Foundation

final class HomeMovieUseCase {
    private let repository: HomeMovieRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: HomeMovieRepository) {
        self.repository = repository
    }
    
    func fetchPopularMovies() -> AnyPublisher<[Movie], Error> {
        return repository.fetchPopularMovies()
    }
    
    func fetchNowPlayingMovies(for date: Date) -> AnyPublisher<[Movie], Error> {
        return repository.fetchNowPlayingMovies(for: date)
    }
    
}

