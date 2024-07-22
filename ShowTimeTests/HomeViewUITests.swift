//
//  HomeViewUITests.swift
//  ShowTimeTests
//
//  Created by MaurZac on 22/07/24.
//

import XCTest

final class HomeViewUITests: XCTestCase {
    
    func testSearchBarUpdates() {
        let app = XCUIApplication()
        app.launch()
        
        let searchBar = app.searchFields["Buscar..."]
        searchBar.tap()
        searchBar.typeText("Test")
        
        let firstResult = app.collectionViews.cells.element(boundBy: 0)
        XCTAssertTrue(firstResult.exists, "The first result should be displayed")
    }
}
