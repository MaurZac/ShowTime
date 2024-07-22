//
//  HomeMovieRepositoryImp.swift
//  ShowTime
//
//  Created by MaurZac on 21/07/24.
//

import Combine
import Foundation

final class HomeMovieRepositoryImp: HomeMovieRepository {
    
        private let apiKey = Config.apiKey
        private let popularMoviesURL: URL
        private var nowPlayingMoviesURL: URL?
        
        init() {
            guard let popularMoviesURL = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc") else {
                fatalError("Invalid URL for popular movies")
            }
            
            self.popularMoviesURL = popularMoviesURL
        }
        
        func fetchPopularMovies() -> AnyPublisher<[Movie], Error> {
            return URLSession.shared.dataTaskPublisher(for: popularMoviesURL)
                .map(\.data)
                .decode(type: MovieResponse.self, decoder: JSONDecoder())
                .map { $0.results }
                .eraseToAnyPublisher()
        }
        
        func fetchNowPlayingMovies(for date: Date) -> AnyPublisher<[Movie], Error> {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let maxDate = dateFormatter.string(from: date)
            
            let calendar = Calendar.current
            guard let minDate = calendar.date(byAdding: .day, value: -7, to: date) else {
                fatalError("Error calculating min date")
            }
            let minDateString = dateFormatter.string(from: minDate)
            
            let urlString = "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc&with_release_type=2|3&release_date.gte=\(minDateString)&release_date.lte=\(maxDate)"
            
            print(urlString)
            
            guard let url = URL(string: urlString) else {
                fatalError("Invalid URL for now playing movies")
            }
            
            return URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: MovieResponse.self, decoder: JSONDecoder())
                .map { $0.results }
                .eraseToAnyPublisher()
        }
    }
