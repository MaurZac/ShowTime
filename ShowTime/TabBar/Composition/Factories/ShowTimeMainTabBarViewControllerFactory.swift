//
//  ShowTimeMainTabBarViewControllerFactory.swift
//  ShowTime
//
//  Created by MaurZac on 21/07/24.
//

import UIKit

protocol ShowTimeMainTabBarViewControllerFactory {
    func makeHomeViewController(coordinator: Coordinator) -> UIViewController
    func makeDetailMovieViewController(movie: Movie) -> UIViewController
    func makeWatchlistViewController(repository: FavoriteMovieRepositoryImpl) -> UIViewController
}

final class ShowTimeMainTabBarViewControllerFactoryImp: ShowTimeMainTabBarViewControllerFactory {
    func makeHomeViewController(coordinator: Coordinator) -> UIViewController {
        let homeNavigationController = UINavigationController()
        let homeViewControllerFactory = HomeViewFactoryImp(navigationController: homeNavigationController)
        let homeCoordinator = HomeViewCoordinator(navigationController: homeNavigationController, viewControllerFactory: homeViewControllerFactory)
        homeCoordinator.start()
        let homeVC = homeNavigationController.viewControllers.first!
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        return homeNavigationController
    }

    func makeDetailMovieViewController(movie: Movie) -> UIViewController {
        let favoriteMovieRepository = FavoriteMovieRepositoryImpl(coreDataManager: CoreDataManager.shared)
        let detailViewModel = DetailMovieViewModel(movie: movie, favoriteMovieRepository: favoriteMovieRepository)
        let detailVC = DetailMovieView(viewModel: detailViewModel, favoriteMovieRepository: favoriteMovieRepository)
        return detailVC
    }

    func makeWatchlistViewController(repository: FavoriteMovieRepositoryImpl) -> UIViewController {
        let viewModel = WatchlistViewModel(favoriteMovieRepository: repository)
        let watchlistVC = WatchlistView(viewModel: viewModel)
        watchlistVC.tabBarItem = UITabBarItem(title: "Watchlist", image: UIImage(systemName: "bookmark.circle"), tag: 1)
        return watchlistVC
    }
       
}

