//
//  HomeViewCoordinator.swift
//  ShowTime
//
//  Created by MaurZac on 21/07/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
    func navigateToDetailMovie(movie: Movie)
    
}

final class HomeViewCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var viewControllerFactory: HomeViewControllerFactory
    
    init(navigationController: UINavigationController, viewControllerFactory: HomeViewControllerFactory) {
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
    }
    
    func start() {
        let homeViewController = HomeViewController()
        homeViewController.coordinator = self
        navigationController.pushViewController(homeViewController, animated: false)
    }
    
    func navigateToDetailMovie(movie: Movie) {
        let favoriteMovieRepository = FavoriteMovieRepositoryImpl(coreDataManager: CoreDataManager.shared)
        let detailViewModel = DetailMovieViewModel(movie: movie, favoriteMovieRepository: favoriteMovieRepository)
        let detailViewController = viewControllerFactory.makeDetailMovieViewController(movie: movie)
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
}
