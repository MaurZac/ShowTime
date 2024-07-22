//
//  HomeMovieRepositoryMock.swift
//  ShowTimeTests
//
//  Created by MaurZac on 22/07/24.
//

class HomeMovieRepositoryMock: HomeMovieRepository {
    func fetchPopularMovies() -> AnyPublisher<[Movie], Error> {
        let movies = [Movie(title: "Mock Movie", posterPath: "")]
        return Just(movies)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchNowPlayingMovies(for date: Date) -> AnyPublisher<[Movie], Error> {
        let movies = [Movie(title: "Mock Now Playing Movie", posterPath: "")]
        return Just(movies)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

