//
//  PokeModels.swift
//  PokedexTests
//
//  Created by Alastair Smith on 29/12/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//
import RealmSwift
import XCTest
@testable import Pokedex

class PokeModels: XCTestCase {

    var pokemon: Pokemon!
    var sprites: Sprites!
    var types: List<PokemonType>!
    var abilities: List<PokemonAbility>!
    var stats: List<PokemonStat>!
    var json: Data!

    var user: User!

    override func setUp() {
        super.setUp()
        sprites = Sprites(sprite: "testurl")
        let type1 = PokemonType(slot: 0, type: propertyName("Grass"))
        let type2 = PokemonType(slot: 1, type: propertyName("Poison"))
        types = List<PokemonType>()
        types.append(objectsIn: [type1, type2])

        let ability1 = PokemonAbility(slot: 0, is_hidden: false, ability: propertyName("Chlorophyll"))
        let ability2 = PokemonAbility(slot: 1, is_hidden: true, ability: propertyName("Overgrow"))
        abilities = List<PokemonAbility>()

        abilities.append(objectsIn: [ability1, ability2])
        let stat1 = PokemonStat(stat: propertyName("HP"), base_stat: 55)
        let stat2 = PokemonStat(stat: propertyName("Attack"), base_stat: 55)
        let stat3 = PokemonStat(stat: propertyName("Defence"), base_stat: 55)
        let stat4 = PokemonStat(stat: propertyName("Special Attack"), base_stat: 55)
        let stat5 = PokemonStat(stat: propertyName("Defence"), base_stat: 55)
        let stat6 = PokemonStat(stat: propertyName("Speed"), base_stat: 55)

        stats = List<PokemonStat>()
        stats.append(objectsIn: [stat1, stat2, stat3, stat4, stat5, stat6])
        pokemon = Pokemon(id: 1,
              name: "Bulbasaur",
              sprites: sprites,
              types: types,
              abilities: abilities,
              stats: stats
        )

        let testBundle = Bundle(for: type(of: self))
        if let path = testBundle.path(forResource: "TestJson", ofType: "json") {
            do {
                json = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            } catch let error {
                print(error.localizedDescription)
        }}

        user = User(userName: "Test user", validated: false)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func propertyName(_ title: String) -> PropertyName {
        return PropertyName(name: title)
    }

    override func tearDown() {
        super.tearDown()
        pokemon = nil
        sprites = nil
        types = nil
        abilities = nil
        stats = nil
        user = nil
    }

    func testPokemonID() {
        XCTAssertEqual(pokemon.id, 1)
    }

    func testPokemonName() {
        XCTAssertEqual(pokemon.name, "Bulbasaur")
    }

    func testPokemonSprites() {
        XCTAssertEqual(pokemon.sprites?.sprite, "testurl")
    }

    func testPokemonType() {
        XCTAssertEqual(pokemon.types.first?.type?.name, "Grass")
    }

    func testPokemonAbilities() {
        XCTAssertEqual(pokemon.abilities.first?.ability?.name, "Chlorophyll")
    }

    func testPokemonStats() {
        XCTAssertEqual(pokemon.stats.first?.stat?.name, "HP")
        XCTAssertEqual(pokemon.stats.first?.base_stat, 55)
    }

    func testSprites() {
        XCTAssertEqual(pokemon.sprites, sprites)
    }

    func testTypes() {
        XCTAssertEqual(pokemon.types, types)
    }

    func testAbilities() {
        XCTAssertEqual(pokemon.abilities, abilities)
    }

    func testStats() {
        XCTAssertEqual(pokemon.stats, stats)
    }

    func testInit() {
        let decoder = JSONDecoder()
        let pokemon = try! decoder.decode(Pokemon.self, from: json)
        XCTAssertEqual(pokemon.id, 200)
    }

    func testSelectedPokemon() {
        let active = ActivePokemon(pokemon: pokemon)
        XCTAssertEqual(active.selectedPokemon?.id, 1)
    }

    func testUsername() {
        XCTAssertEqual(user.userName, "Test user")
    }

    func testUserValidation() {
        XCTAssertEqual(user.validated, false)
    }
}
