//
//  HomeViewModel.swift
//  ShowTime
//
//  Created by MaurZac on 20/07/24.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var isSearchBarExpanded: Bool = false
    @Published var movies: [Movie] = []
    @Published var nowMovies: [Movie] = []
    @Published var filteredMovies: [Movie] = []
    @Published var filteredNowPlaying: [Movie] = []
    
    private var fetchMovieUseCase: HomeMovieUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(fetchMovieUseCase: HomeMovieUseCase) {
        self.fetchMovieUseCase = fetchMovieUseCase
        loadMovies()
        loadNowPlaying()
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                self?.searchMovies(with: searchText)
            }
            .store(in: &cancellables)
    }
    
    func loadMovies() {
        fetchMovieUseCase.fetchPopularMovies()
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error fetching popular movies: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] movies in
                self?.movies = movies
                self?.filteredMovies = movies
            })
            .store(in: &cancellables)
    }
    
    func loadNowPlaying() {
        let currentDate = Date()
        fetchMovieUseCase.fetchNowPlayingMovies(for: currentDate)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error fetching now playing movies: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] nowMovies in
                
                self?.nowMovies = nowMovies
                self?.filteredNowPlaying = nowMovies
            })
            .store(in: &cancellables)
    }
    
    func searchMovies(with query: String) {
        if query.isEmpty {
            filteredMovies = movies
            filteredNowPlaying = nowMovies
        } else {
            filteredMovies = movies.filter { movie in
                let nameMatches = movie.title.lowercased().contains(query.lowercased())
                let descriptionMatches = movie.title.lowercased().contains(query.lowercased())
                return nameMatches || descriptionMatches
            }
            filteredNowPlaying = nowMovies.filter { movie in
                let nameMatches = movie.title.lowercased().contains(query.lowercased())
                return nameMatches
            }
        }
    }
}
