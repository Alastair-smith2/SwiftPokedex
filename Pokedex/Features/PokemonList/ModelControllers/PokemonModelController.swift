//
//  PokemonModelController.swift
//  Pokdex
//
//  Created by Alastair Smith on 31/10/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//

import Foundation
import RealmSwift

typealias ImageParams = (pokemonId: Int, image: UIImage)

class PokemonModelController {
    private let networkService: NetworkManager
    private let realmHelper: RealmHelper
    private let imageManager: ImageCacheManager
    var searchActive: Bool = false
    var displayedResults: Results<Pokemon>?
    private var pokemonData: Results<Pokemon>?

    init(networkService: NetworkManager, realmHelper: RealmHelper = RealmHelper(), imageManager: ImageCacheManager) {
        self.networkService = networkService
        self.realmHelper = realmHelper
        self.imageManager = imageManager
    }
}

extension PokemonModelController {
    func setUpTable(closure: @escaping (Bool) -> Void) {
        let pokemonResult = realmHelper.loadPokemon()
        if pokemonResult.count == 0 {
            getPokemonData { pokemonResult in
                switch pokemonResult {
                case .success:
                    closure(true)
                case .failure:
                    closure(false)
                }
            }
        } else {
            pokemonData = pokemonResult
            displayedResults = pokemonResult
            closure(true)
        }
    }

    func getPokemonData(closure: @escaping (Result<[Pokemon]>) -> Void) {
        getInitialPokemon { [weak self] result in
            switch result {
            case let .success(pokemonSummary):
                self?.getIndividualPokemon(pokemonSummary) { pokemonListResult in
                    switch pokemonListResult {
                    case let .success(pokemonList):
                        closure(.success(pokemonList))
                    case let .failure(listError):
                        closure(.failure(listError))
                    }
                }
            case let .failure(summaryError):
                closure(.failure(summaryError))
            }
        }
    }

    func getInitialPokemon(closure: @escaping (Result<PokemonSummaryResult>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.networkService.getPokemon { apiResponse in
                switch apiResponse {
                case let .success(pokemonResult):
                    DispatchQueue.main.async {
                        closure(.success(pokemonResult))
                    }
                case let .failure(error):
                    closure(.failure(error))
                }
            }
        }
    }

    func getIndividualPokemon(_ summaryResult: PokemonSummaryResult, closure: @escaping (Result<[Pokemon]>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let group = DispatchGroup()
            var pokemonList: [Pokemon] = []
            for index in summaryResult.results.indices {
                group.enter()
                self.networkService.getIndividualPokemon(index + 1) { apiResult in
                    switch apiResult {
                    case let .success(newPokemon):
                        pokemonList.append(newPokemon)
                        group.leave()
                    case .failure:
                        group.leave()
                    }
                }
            }

            group.notify(queue: .main) { [weak self] in
                self?.realmHelper.save(pokemonList)
                self?.displayedResults = self?.realmHelper.loadPokemon()
                closure(.success(pokemonList))
            }
        }
    }

    func setActivePokemon(_ id: Int, closure: @escaping (Bool) -> Void) {
        let selectedPokemon = pokemonData?.filter("id == \(id)")
        if let selectedExist = selectedPokemon?.first {
            let activePokemon = ActivePokemon(pokemon: selectedExist)
            realmHelper.save(activePokemon)
            closure(true)
        } else {
            closure(false)
        }
    }
}

protocol PokemonModelControllerSearch {
    func endSearch()
    func filterContent(for searchText: String)
}

protocol PokemonListImageHandler {
    func downloadImage(_ url: URL, _ pokeId: Int, completion: @escaping (Result<Data>) -> Void)
    func cancelImageDownload(_ pokeId: Int)
    func cacheImage(_ imageParams: ImageParams)
    func getCachedImage(_ pokemonId: Int) -> UIImage?
}

extension PokemonModelController: PokemonModelControllerSearch {
    func endSearch() {
        displayedResults = pokemonData
    }

    func filterContent(for searchText: String) {
        displayedResults = pokemonData?.filter("name contains %@", searchText)
    }
}

extension PokemonModelController: PokemonListImageHandler {
    func downloadImage(_ url: URL, _ pokeId: Int, completion: @escaping (Result<Data>) -> Void) {
        networkService.downloadImage(url, pokeId) { result in
            switch result {
            case let .success(imageData):
                completion(.success(imageData))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func cancelImageDownload(_ pokeId: Int) {
        networkService.cancelDownloadImage(pokeId)
    }

    func cacheImage(_ imageParams: ImageParams) {
        imageManager.cacheImage(imageParams.pokemonId, imageParams.image)
    }

    func getCachedImage(_ pokemonId: Int) -> UIImage? {
        return imageManager.getCachedImage(pokemonId)
    }
}
