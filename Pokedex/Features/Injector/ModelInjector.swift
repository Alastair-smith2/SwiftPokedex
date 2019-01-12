//
//  ModelInjector.swift
//  Pokdex
//
//  Created by Alastair Smith on 22/10/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//

import Foundation

protocol ModelControlerInjector {
    func addUserController() -> UserModelController
    func addPokemonModelController() -> PokemonModelController
    func addPokemonDetailModelController() -> PokemonDetailModelController
}
