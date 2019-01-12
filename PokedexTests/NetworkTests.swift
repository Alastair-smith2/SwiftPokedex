//
//  NetworkTests.swift
//  PokedexTests
//
//  Created by Alastair Smith on 29/12/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//

import XCTest
@testable import Pokedex

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    // We override the 'resume' method and simply call our closure
    // instead of actually resuming any task.
    override func resume() {
        closure()
    }
}

class URLSessionMock: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

    // Properties that enable us to set exactly what data or error
    // we want our mocked URLSession to return for any request.
    var data: Data?
    var response: URLResponse?
    var error: Error?

    override func dataTask(
        with url: URLRequest,
        completionHandler: @escaping CompletionHandler
        ) -> URLSessionDataTask {
        let data = self.data
        let response = self.response
        let error = self.error

        return URLSessionDataTaskMock {
            completionHandler(data, response, error)
        }
    }
}

class NetworkTests: XCTestCase {

    var individualJson: Data!
    var summaryJson: Data!
    var session: URLSessionMock!
    var networkManager: NetworkManager!
    let decoder = JSONDecoder()

    override func setUp() {
        super.setUp()
        let testBundle = Bundle(for: type(of: self))
        if let individualPath = testBundle.path(forResource: "TestJson", ofType: "json"), let summaryPath = testBundle.path(forResource: "SummaryJson", ofType: "json") {
            do {
                individualJson = try Data(contentsOf: URL(fileURLWithPath: individualPath), options: .alwaysMapped)
                summaryJson = try Data(contentsOf: URL(fileURLWithPath: summaryPath), options: .alwaysMapped)
            } catch let error {
                print(error.localizedDescription)
            }}

        session = URLSessionMock()
        networkManager = NetworkManager(session: session)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        super.tearDown()
        individualJson = nil
        summaryJson = nil
        session = nil
        networkManager = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSuccessResponse() {
        let summaryResult = try! decoder.decode(PokemonSummaryResult.self, from: summaryJson)
        session.data = summaryJson
        let response = HTTPURLResponse(url: URL(string: "fakeResponse")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.response = response!
        var success: PokemonSummaryResult?
        var error: Error?
        networkManager.getPokemon { mockResult in
            switch mockResult {
            case let .success(json):
                success = json
            case let .failure(networkError):
                error = networkError
            }
        }
        XCTAssertEqual(success!.count, summaryResult.count)
        XCTAssertEqual(success!.results[0].url, summaryResult.results[0].url)
        XCTAssertTrue(error == nil)
    }

    func testErrorInRequest() {
        session.data = summaryJson
        let response = HTTPURLResponse(url: URL(string: "fakeResponse")!, statusCode: 900, httpVersion: nil, headerFields: nil)
        session.response = response!
        session.error = NetworkError.missingURL
        var success: PokemonSummaryResult?
        var error: Error?
        networkManager.getPokemon { mockResult in
            switch mockResult {
            case let .success(json):
                success = json
            case let .failure(networkError):
                error = networkError
            }
        }
        XCTAssertTrue(success == nil)
        XCTAssertTrue(error != nil)
    }

    func testIndividualPokemon() {
        let bulbasaur: Pokemon = try! decoder.decode(Pokemon.self, from: individualJson)
        session.data = individualJson
        let response = HTTPURLResponse(url: URL(string: "fakeResponse")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.response = response!
        var success: Pokemon?
        var error: Error?
        networkManager.getIndividualPokemon(bulbasaur.id) { mockResult in
            switch mockResult {
            case let .success(json):
                success = json
            case let .failure(networkError):
                error = networkError
            }
        }
        XCTAssertEqual(bulbasaur.id, success!.id)
        XCTAssertTrue(error == nil)
    }

}
