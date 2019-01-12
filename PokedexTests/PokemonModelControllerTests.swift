//
//  PokemonModelControllerTests.swift
//  PokedexTests
//
//  Created by Alastair Smith on 31/12/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//
import RealmSwift
import XCTest
@testable import Pokedex

class PokemonModelControllerTests: XCTestCase {

    var individualJson: Data!
    var summaryJson: Data!
    var bulbasaurSummaryJson: Data!
    var session: URLSessionMock!
    var networkManager: NetworkManager!
    let decoder = JSONDecoder()
    var modelController: PokemonModelController!
    var realmHelper: RealmHelper!
    var imageCacher: ImageCacheManager!

    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        realmHelper = RealmHelper()
        imageCacher = ImageCacheManager()
        session = URLSessionMock()
        networkManager = NetworkManager(session: session)
        modelController = PokemonModelController(networkService: networkManager, realmHelper: realmHelper, imageManager: imageCacher)

        let testBundle = Bundle(for: type(of: self))
        if let individualPath = testBundle.path(forResource: "TestJson", ofType: "json"),
            let summaryPath = testBundle.path(forResource: "SummaryJson", ofType: "json"),
            let bulbasaurPath = testBundle.path(forResource: "SummaryJsonSingle", ofType: "json") {
            do {
                individualJson = try Data(contentsOf: URL(fileURLWithPath: individualPath), options: .alwaysMapped)
                summaryJson = try Data(contentsOf: URL(fileURLWithPath: summaryPath), options: .alwaysMapped)
                bulbasaurSummaryJson = try Data(contentsOf: URL(fileURLWithPath: bulbasaurPath), options: .alwaysMapped)
            } catch let error {
                print(error.localizedDescription)
            }}
    }

    override func tearDown() {
        super.tearDown()
    }

    func testLoadingPreviousPokemon() {
        let bulbasaur = try! decoder.decode(Pokemon.self, from: individualJson)
        _ = realmHelper.save(bulbasaur)
        session.data = individualJson
        let response = HTTPURLResponse(url: URL(string: "fakeResponse")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.response = response!
        var result: Bool?
        modelController.setUpTable { setupResult in
            result = setupResult
        }
        XCTAssertEqual(result!, true)
        XCTAssertEqual(modelController.displayedResults!.count, 1)
    }

    func testInitialPokemon() {
        let summaryJsonDecoded = try! decoder.decode(PokemonSummaryResult.self, from: summaryJson)
        session.data = summaryJson
        let response = HTTPURLResponse(url: URL(string: "fakeResponse")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.response = response!
        var result: PokemonSummaryResult?
        var error: Error?
        modelController.getInitialPokemon { pokeResult in
            switch pokeResult {
            case let .success(summary):
                result = summary
            case let .failure(fail):
                error = fail
            }
        }
        XCTAssertEqual(summaryJsonDecoded.count, result!.count)
    }

    func testIndividualPokemon() {
        let bulbJson = try! decoder.decode(PokemonSummaryResult.self, from: bulbasaurSummaryJson)
        session.data = individualJson
        let response = HTTPURLResponse(url: URL(string: "fakeResponse")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.response = response!
        var result: [Pokemon]?
        var error: Error?
        // required here due to the use of dispatch group
        let expectation = self.expectation(description: "PokemonData")
        modelController.getIndividualPokemon(bulbJson) { pokeResult in
            switch pokeResult {
            case let .success(poke):
                result = poke
                expectation.fulfill()
            case let .failure(fail):
                error = fail
                expectation.fulfill()
            }
        }
         waitForExpectations(timeout: 2, handler: nil)
         XCTAssertEqual(bulbJson.results.first!.name, result!.first!.name)
    }
}
