//
//  PokemonDetailViewControllerTests.swift
//  PokedexTests
//
//  Created by Alastair Smith on 31/12/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//

import RealmSwift
import XCTest
@testable import Pokedex

class PokemonDetailViewControllerTests: XCTestCase {

    var modelController: PokemonDetailModelController!
    var realmHelper: RealmHelper!
    var imageCacher: ImageCacheManager!
    var vc: PokemonDetailViewController!
    var activePokemon: ActivePokemon!

    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        realmHelper = RealmHelper()
        let sprites = Sprites(sprite: "testurl")
        let type1 = PokemonType(slot: 0, type: propertyName("Grass"))
        let type2 = PokemonType(slot: 1, type: propertyName("Poison"))
        let types = List<PokemonType>()
        types.append(objectsIn: [type1, type2])

        let ability1 = PokemonAbility(slot: 0, is_hidden: false, ability: propertyName("Chlorophyll"))
        let ability2 = PokemonAbility(slot: 1, is_hidden: true, ability: propertyName("Overgrow"))
        let abilities = List<PokemonAbility>()

        abilities.append(objectsIn: [ability1, ability2])
        let stat1 = PokemonStat(stat: propertyName("HP"), base_stat: 55)
        let stat2 = PokemonStat(stat: propertyName("Attack"), base_stat: 55)
        let stat3 = PokemonStat(stat: propertyName("Defence"), base_stat: 55)
        let stat4 = PokemonStat(stat: propertyName("Special Attack"), base_stat: 55)
        let stat5 = PokemonStat(stat: propertyName("Defence"), base_stat: 55)
        let stat6 = PokemonStat(stat: propertyName("Speed"), base_stat: 55)

        let stats = List<PokemonStat>()
        stats.append(objectsIn: [stat1, stat2, stat3, stat4, stat5, stat6])
        let pokemon = Pokemon(id: 1,
                          name: "Bulbasaur",
                          sprites: sprites,
                          types: types,
                          abilities: abilities,
                          stats: stats
        )

        imageCacher = ImageCacheManager()
        modelController = PokemonDetailModelController(imageManager: imageCacher, realmHelper: realmHelper)
        activePokemon = ActivePokemon(pokemon: pokemon)
        realmHelper.save(activePokemon)
        let nav = UINavigationController()
        vc = PokemonDetailViewController(coordinator:
            MainCoordinator(navigationController: nav),
                            controller: modelController)
        // call super.viewDidLoad
        _ = vc.view
    }

    func propertyName(_ title: String) -> PropertyName {
        return PropertyName(name: title)
    }

    override func tearDown() {
        super.tearDown()
        modelController = nil
        realmHelper = nil
        imageCacher = nil
        vc = nil
    }

    func testTitle() {
        XCTAssertEqual(vc.title!, "\(activePokemon.selectedPokemon!.name) - \(activePokemon.selectedPokemon!.id)")
    }

    func testLabel() {
        let text = "Hp"
        let label = vc.generateLabel("Hp")
        XCTAssertEqual(label.text!, text)
    }

    func testStackView() {
        let stack = vc.generateStackView(.horizontal, spacing: 5, alignment: .center, distribution: .fillEqually)
        XCTAssertEqual(stack.alignment, .center)
    }

}
