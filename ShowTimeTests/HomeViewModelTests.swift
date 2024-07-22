//
//  HomeViewModelTests.swift
//  ShowTimeTests
//
//  Created by MaurZac on 22/07/24.
//

import Combine
import XCTest
@testable import ShowTime
final class HomeViewModelTests: XCTestCase {
    private var viewModel: HomeViewModel!
        private var cancellables: Set<AnyCancellable> = []
        
        override func setUp() {
            super.setUp()
            let repository = HomeMovieRepositoryImp()
            let fetchMovieUseCase = HomeMovieUseCase(repository: repository)
            viewModel = HomeViewModel(fetchMovieUseCase: fetchMovieUseCase)
        }
        
        override func tearDown() {
            viewModel = nil
            cancellables = []
            super.tearDown()
        }
        
        func testLoadMovies() {
            let expectation = XCTestExpectation(description: "Load movies")
            
            viewModel.$filteredMovies
                .dropFirst() // Ignora el valor inicial
                .sink { movies in
                    XCTAssertFalse(movies.isEmpty, "Filtered movies should not be empty")
                    expectation.fulfill()
                }
                .store(in: &cancellables)
            
            viewModel.loadMovies()
            
            wait(for: [expectation], timeout: 5.0)
        }
        
        func testSearchMovies() {
            let expectation = XCTestExpectation(description: "Search movies")
            
            viewModel.movies = [Movie(title: "Test Movie", posterPath: "")]
            viewModel.searchText = "Test"
            
            viewModel.$filteredMovies
                .dropFirst()
                .sink { movies in
                    XCTAssertEqual(movies.count, 1, "Filtered movies should contain the search result")
                    expectation.fulfill()
                }
                .store(in: &cancellables)
            
            viewModel.searchMovies(with: "Test")
            
            wait(for: [expectation], timeout: 5.0)
        }

}
