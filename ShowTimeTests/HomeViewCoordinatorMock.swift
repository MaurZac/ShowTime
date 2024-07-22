//
//  HomeViewCoordinatorMock.swift
//  ShowTimeTests
//
//  Created by MaurZac on 22/07/24.
//

import Foundation
@testable import ShowTime

class HomeViewCoordinatorMock: HomeViewCoordinator {
    
    var didNavigateToDetailMovie = false
    var lastSelectedMovie: Movie?
    
    override func navigateToDetailMovie(movie: Movie) {
        didNavigateToDetailMovie = true
        lastSelectedMovie = movie
    }
}
