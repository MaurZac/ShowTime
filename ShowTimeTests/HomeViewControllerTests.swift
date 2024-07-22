//
//  HomeViewControllerTests.swift
//  ShowTimeTests
//
//  Created by MaurZac on 22/07/24.
//

import XCTest
@testable import ShowTime

final class HomeViewControllerTests: XCTestCase {

    private var viewController: HomeViewController!
    var viewModel: HomeViewModel!
    private var coordinator: HomeViewCoordinatorMock!

    override func setUp() {
        super.setUp()
        let repository = HomeMovieRepositoryImp()
        let navigationController = UINavigationController()
        let factory = HomeViewControllerFactoryMock()

        let fetchMovieUseCase = HomeMovieUseCase(repository: repository)
        viewModel = HomeViewModel(fetchMovieUseCase: fetchMovieUseCase)
        coordinator = HomeViewCoordinatorMock(navigationController: navigationController, viewControllerFactory: factory)
        viewController = HomeViewController()
        viewController.viewModel = viewModel
        viewController.coordinator = coordinator
        viewController.loadViewIfNeeded()
    }

    override func tearDown() {
        viewController = nil
        viewModel = nil
        coordinator = nil
        super.tearDown()
    }
    
    func testViewControllerSetup() {
        XCTAssertNotNil(viewController.collectionView, "collectionView should be initialized")
        XCTAssertNotNil(viewController.searchBar, "searchBar should be initialized")
    }
    
    func testSearchBarUpdate() {
        viewController.searchBar(searchBar, textDidChange: "Test")
        XCTAssertEqual(viewModel.searchText, "Test", "ViewModel searchText should be updated")
    }
}
