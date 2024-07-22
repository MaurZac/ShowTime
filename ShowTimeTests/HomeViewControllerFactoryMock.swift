//
//  HomeViewControllerFactoryMock.swift
//  ShowTimeTests
//
//  Created by MaurZac on 22/07/24.
//

import UIKit

protocol HomeViewControllerFactory {
    func createHomeViewController() -> HomeViewControllerTests
}

class HomeViewControllerFactoryMock: HomeViewControllerFactory {
    func createHomeViewController() -> HomeViewControllerTests {
        return HomeViewControllerTests()
    }
}

