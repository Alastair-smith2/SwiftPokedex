//
//  PokemonListViewControllerTests.swift
//  PokedexTests
//
//  Created by Alastair Smith on 31/12/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//
import RealmSwift
import XCTest
@testable import Pokedex

class PokemonListViewControllerTests: XCTestCase {

    var modelController: PokemonModelController!
    var realmHelper: RealmHelper!
    var imageCacher: ImageCacheManager!
    var networkManager: NetworkManager!
    var vc: PokemonTableViewController!

    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        realmHelper = RealmHelper()
        imageCacher = ImageCacheManager()
        networkManager = NetworkManager(session: URLSessionMock())
        modelController = PokemonModelController(networkService: networkManager, realmHelper: realmHelper, imageManager: imageCacher)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        vc = storyboard.instantiateViewController(withIdentifier: "PokemonTableViewController") as! PokemonTableViewController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        super.tearDown()
        modelController = nil
        realmHelper = nil
        imageCacher = nil
        networkManager = nil
        vc = nil
    }

    func testExample() {
       _ = vc.view
        XCTAssertEqual(vc.title!, "Pokedex")
    }

}
