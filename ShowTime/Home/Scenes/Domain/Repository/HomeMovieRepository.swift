//
//  HomeMovieRepository.swift
//  ShowTime
//
//  Created by MaurZac on 21/07/24.
//
import Foundation
import Combine

protocol HomeMovieRepository {
    func fetchPopularMovies() -> AnyPublisher<[Movie], Error>
    func fetchNowPlayingMovies(for date: Date) -> AnyPublisher<[Movie], Error>
}



