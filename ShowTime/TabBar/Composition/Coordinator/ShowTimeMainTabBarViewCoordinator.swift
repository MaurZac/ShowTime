//
//  ShowTimeMainTabBarViewCoordinator.swift
//  ShowTime
//
//  Created by MaurZac on 21/07/24.
//

import UIKit

final class ShowTimeMainTabBarViewCoordinator: Coordinator {
    var navigationController: UINavigationController
    var viewControllerFactory: ShowTimeMainTabBarViewControllerFactory

    init(navigationController: UINavigationController, viewControllerFactory: ShowTimeMainTabBarViewControllerFactory) {
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
    }

    func start() {
        let mainTabBarViewModel = ShowTimeMainTabBarViewModel()
        let mainTabBarController = ShowTimeMainTabBarView(viewModel: mainTabBarViewModel, coordinator: self, viewControllerFactory: viewControllerFactory)
        navigationController.setViewControllers([mainTabBarController], animated: false)
    }

    func startHome() {
        let homeViewController = viewControllerFactory.makeHomeViewController(coordinator: self)
        navigationController.pushViewController(homeViewController, animated: false)
    }

    func navigateToDetailMovie(movie: Movie) {
        let detailViewController = viewControllerFactory.makeDetailMovieViewController(movie: movie)
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
    func navigateToWatchlist() {
         let favoriteMovieRepository = FavoriteMovieRepositoryImpl(coreDataManager: CoreDataManager.shared)
         let watchlistViewController = viewControllerFactory.makeWatchlistViewController(repository: favoriteMovieRepository)
         navigationController.pushViewController(watchlistViewController, animated: true)
     }
}

