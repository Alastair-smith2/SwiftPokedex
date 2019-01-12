//  PokemonDetailModelController.swift
//  Pokdex
//
//  Created by Alastair Smith on 20/11/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//
import Foundation
import UIKit

class PokemonDetailModelController {
    private let imageManager: ImageCacheManager
    private let realmHelper: RealmHelper
    init(imageManager: ImageCacheManager, realmHelper: RealmHelper) {
        self.imageManager = imageManager
        self.realmHelper = realmHelper
    }

    func getCachedImage(_ pokemonId: Int) -> UIImage? {
        return imageManager.getCachedImage(pokemonId)
    }

    func loadSelectedPokemon() -> Pokemon? {
        return realmHelper.loadSelected().first?.selectedPokemon
    }
}
