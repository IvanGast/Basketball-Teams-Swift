//
//  BasketballTeamsUITests.swift
//  BasketballTeamsUITests
//
//  Created by Ivan on 09/07/2019.
//  Copyright © 2019 Ivan. All rights reserved.
//

import XCTest
@testable import BasketballTeams

class BasketballTeamsUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()

        continueAfterFailure = false


    }

    override func tearDown() {}

    func testLastCellIsLoadedAndHittable() {
        app.swipeUp()
        app.swipeUp()
        app.swipeUp()
        app.swipeUp()
        app.swipeUp()
        app.swipeUp()
        let cell = app.collectionViews.firstMatch.cells.element(matching: .cell, identifier: "teamCell19")
        XCTAssert(cell.exists && cell.isHittable)
    }

    func testImageAndTableAreLoadedAfterViewTapped(){
        let cell = app.collectionViews.firstMatch.cells.element(boundBy: 0)
        cell.tap()
        XCTAssert(app.images["hallImage"].exists)
        app.swipeUp()
        let newsCell = app.tables.firstMatch.cells.element(matching: .cell, identifier: "newsCell0")
        XCTAssert(newsCell.exists)
    }
    
    func testTablesLoadWhenSegmentSwitched() {
        app.collectionViews.firstMatch.tap()
        app.buttons["Players"].tap()
        let playerCell = app.tables.firstMatch.cells.element(matching: .cell, identifier: "playerCell0")
        app.swipeUp()
        XCTAssert(playerCell.exists)
        app.buttons["News"].tap()
        let newsCell = app.tables.firstMatch.cells.element(matching: .cell, identifier: "newsCell0")
        app.swipeUp()
        XCTAssert(newsCell.exists)
        XCTAssert(!playerCell.exists)
    }
    
    func testAfterSwipeSegmentIsSwitchedAndTableIsLoaded(){
        app.collectionViews.firstMatch.tap()
        app.swipeLeft()
        let playerCell = app.tables.firstMatch.cells.element(matching: .cell, identifier: "playerCell0")
        XCTAssertTrue(app.segmentedControls.buttons.element(boundBy: 1).isSelected && playerCell.exists)
        app.swipeUp()
        app.swipeRight()
        let newsCell = app.tables.firstMatch.cells.element(matching: .cell, identifier: "newsCell0")
        XCTAssertTrue(app.segmentedControls.buttons.element(boundBy: 0).isSelected && newsCell.exists)
        app.swipeLeft()
        app.swipeRight()
        app.swipeUp()
        app.swipeLeft()
        app.swipeRight()
    }
    
    func testSelectedPlayerPageIsLoadedAndBackButtonWorks(){
        app.collectionViews.firstMatch.tap()
        app.swipeLeft()
        app.tables.firstMatch.cells.element(matching: .cell, identifier: "playerCell0").tap()
        let playerCell = app.tables.firstMatch.cells.element(matching: .cell, identifier: "myCell0")
        XCTAssertTrue(playerCell.exists)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()
        let mainViewCell = app.collectionViews.firstMatch.cells.element(boundBy: 0)
        XCTAssertTrue(mainViewCell.exists)
    }

    func testEverything(){
        app.collectionViews.firstMatch.tap()
        app.swipeLeft()
        app.swipeUp()
        app.tables.firstMatch.cells.element(matching: .cell, identifier: "playerCell8").tap()
        XCTAssertTrue(app.tables.firstMatch.cells.element(matching: .cell, identifier: "myCell0").exists)
        app.swipeUp()
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.collectionViews.firstMatch.cells.element(boundBy: 0).exists)
        app.collectionViews.firstMatch.cells.element(boundBy: 0).tap()
        app.swipeLeft()
        app.swipeUp()
        app.swipeRight()
        app.swipeUp()
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.swipeUp()
        app.collectionViews.firstMatch.cells.element(boundBy: 0).tap()
        app.swipeLeft()
        app.tables.firstMatch.cells.element(boundBy: 0).tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.swipeRight()
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.swipeUp()
    }
    
}
