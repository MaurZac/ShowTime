//
//  ShowTimeMainTabBarView.swift
//  ShowTime
//
//  Created by MaurZac on 21/07/24.
//

import UIKit
import Combine

final class ShowTimeMainTabBarView: UITabBarController {
    
    private var viewModel: ShowTimeMainTabBarViewModel!
    private var cancellables = Set<AnyCancellable>()
    private var coordinator: ShowTimeMainTabBarViewCoordinator
    private var viewControllerFactory: ShowTimeMainTabBarViewControllerFactory
    
    init(viewModel: ShowTimeMainTabBarViewModel, coordinator: ShowTimeMainTabBarViewCoordinator, viewControllerFactory: ShowTimeMainTabBarViewControllerFactory) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.viewControllerFactory = viewControllerFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        setupBindings()
        
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .gray
        tabBar.backgroundColor = .black
        
        for item in tabBar.items ?? [] {
            item.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14)], for: .normal)
        }
    }
    
    private func setupViewControllers() {
        let homeVC = viewControllerFactory.makeHomeViewController(coordinator: coordinator)
        let favoriteMovieRepository = FavoriteMovieRepositoryImpl(coreDataManager: CoreDataManager.shared)
        
        let watchList = viewControllerFactory.makeWatchlistViewController(repository: favoriteMovieRepository)
        viewControllers = [homeVC, watchList]
    }
    
    private func setupBindings() {
        viewModel.$selectedTab
            .sink { [weak self] selectedIndex in
                self?.selectedIndex = selectedIndex
            }
            .store(in: &cancellables)
    }
}
