//
//  PokemonEndPoint.swift
//  Pokedex
//
//  Created by Alastair Smith on 14/12/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//

import Foundation

enum NetworkEnvironment {
    case production
}

public enum PokemonAPI {
    case all
    case individual(pokeId: Int)
}

extension PokemonAPI: EndPointType {
    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .production: return "https://pokeapi.co/api/v2"
        }
    }

    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.") }
        return url
    }

    var path: String {
        switch self {
        case .all:
            return "pokemon/"
        case let .individual(pokeId):
            return "pokemon/\(pokeId)"
        }
    }

    var httpMethod: HTTPMethod {
        return .get
    }

    var task: HTTPTask {
        return .request
    }

    var headers: HTTPHeaders? {
        return nil
    }
}
