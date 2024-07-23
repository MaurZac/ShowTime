//
//  HomeViewFactoryImplementation.swift
//  ShowTime
//
//  Created by MaurZac on 21/07/24.
//

import Foundation
import UIKit

protocol HomeViewControllerFactory {
    func makeDetailMovieViewController(movie: Movie) -> DetailMovieView
}

final class HomeViewFactoryImp: HomeViewControllerFactory {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func makeDetailMovieViewController(movie: Movie) -> DetailMovieView {
        print(navigationController)
        let favoriteMovieRepository = FavoriteMovieRepositoryImpl(coreDataManager: CoreDataManager.shared)
        
        let viewModel = DetailMovieViewModel(movie: movie, favoriteMovieRepository: favoriteMovieRepository)
        return DetailMovieView(viewModel: viewModel, favoriteMovieRepository: favoriteMovieRepository)
    }
    
}
