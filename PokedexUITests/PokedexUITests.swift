//
//  PokedexUITests.swift
//  PokedexUITests
//
//  Created by Alastair Smith on 01/12/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//

import XCTest
@testable import Pokedex

class PokedexUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        super.tearDown()
        app = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func navigateAuth() {
        let usernameTextField = app.textFields["username"]
        let passwordTextField = app.secureTextFields["password"]
        let submitButton = app.buttons["Submit"]
        usernameTextField.tap()
        usernameTextField.typeText("FakeUser")
        passwordTextField.tap()
        passwordTextField.typeText("helloworld")
        submitButton.tap()
    }

    func navigateToPokemon() {
        navigateAuth()
        let cell = app.tables.cells["bulbasaur"]
        cell.tap()
    }

    func testExists() {
        app.launch()
        let submitButton = app.buttons.firstMatch
        XCTAssert(submitButton.label == "Submit")
    }

    func testButtonDisabled() {
        app.launch()
        let submitButton = app.buttons.firstMatch
        XCTAssert(submitButton.isEnabled == false)
    }

    func testAuthSubmit() {
        app.launch()
        navigateAuth()
        XCTAssert(app.tables.staticTexts.count > 0)
    }

    func testIndividualPageImage() {
        app.launch()
        navigateToPokemon()
        let image = app.images["pokemonImage"]
        XCTAssert(image.waitForExistence(timeout: 1))
    }

    func testIndividualPageLabels() {
        app.launch()
        navigateToPokemon()
        let label = app.staticTexts["Hp"]
        XCTAssert(label.waitForExistence(timeout: 1))
    }
}
