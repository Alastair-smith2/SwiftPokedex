//
//  RealmTests.swift
//  PokedexTests
//
//  Created by Alastair Smith on 29/12/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//
import RealmSwift
@testable import Pokedex
import XCTest

class RealmTests: XCTestCase {

    var database: RealmHelper!
    var bulbasaur: Pokemon!
    var squirtle: Pokemon!
    var testPokemon: [Pokemon]!

    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        database = RealmHelper()
        bulbasaur = Pokemon(id: 1,
                                name: "Bulbasaur",
                                sprites: Sprites(sprite: "testurl"),
                                types: List<PokemonType>(),
                                abilities: List<PokemonAbility>(),
                                stats: List<PokemonStat>()
        )

        squirtle = Pokemon(id: 3,
                               name: "Squirtle",
                               sprites: Sprites(sprite: "testurl"),
                               types: List<PokemonType>(),
                               abilities: List<PokemonAbility>(),
                               stats: List<PokemonStat>()
        )

        testPokemon = [bulbasaur, squirtle]
          _ = database.save(testPokemon)
    }

    override func tearDown() {
        super.tearDown()
        _ = database.deleteRealm()
        database = nil
        bulbasaur = nil

        squirtle = nil

        testPokemon = nil
    }

    func testSave() {
        let updatedSquirtle = Pokemon(id: 3,
                                      name: "Squirtle",
                                      sprites: Sprites(sprite: "squirtleIsBest"),
                                      types: List<PokemonType>(),
                                      abilities: List<PokemonAbility>(),
                                      stats: List<PokemonStat>()
        )
        _ = database.save(updatedSquirtle)
        let updatedPokemon = database.loadPokemon()
        let updatedSquirtleResult = updatedPokemon.filter("id == 3").first

        XCTAssertEqual(updatedSquirtleResult?.sprites?.sprite, "squirtleIsBest")
    }
    

    func testIndividualPokemon() {
        let individualPokemon = database.loadPokemon()
        XCTAssertEqual(individualPokemon.count, 2)
    }

    func testSelectedPokemon() {
        let selectedPokemon = ActivePokemon(pokemon: squirtle)
        _ = database.save(selectedPokemon)
        let activePoke = database.loadSelected()
        XCTAssertEqual(activePoke.first?.selectedPokemon?.id, 3)
    }

    func testDelete() {
        _ = database.deleteRealm()
        let nonExistPokemon = database.loadPokemon()
        XCTAssertEqual(nonExistPokemon.count, 0)
    }
}
