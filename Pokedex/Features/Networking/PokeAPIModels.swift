//
//  PokeAPIModels.swift
//  Pokedex
//
//  Created by Alastair Smith on 08/12/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//

import Foundation

struct PokemonSummaryResult: Codable {
    let count: Int
    let results: [PokemonSummary]
}

struct PokemonSummary: Codable {
    let name: String
    let url: URL
}
