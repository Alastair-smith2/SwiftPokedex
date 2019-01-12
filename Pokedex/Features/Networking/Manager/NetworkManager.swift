//
//  NetworkManager.swift
//  Pokedex
//
//  Created by Alastair Smith on 14/12/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//

import Foundation

enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum NetworkResponseError: Error {
    case error(String)
}

enum APIResponse<T: Decodable> {
    case success(T)
    case failure(Error)
}

enum NetworkResult<String> {
    case success
    case failure(String)
}

protocol ImageLoader {
    func downloadImage(_ url: URL, _ pokeId: Int, completion: @escaping (Result<Data>) -> Void)
    var session: URLSession { get }
    var imageDownloadOperations: [Int: URLSessionDataTask] { get set }
}

class ImageHandler: ImageLoader {
    internal let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    let queue = DispatchQueue(label: "pokemon", qos: .userInitiated)
    var imageDownloadOperations: [Int: URLSessionDataTask] = [:]

    func downloadImage(_ url: URL, _ pokeId: Int, completion: @escaping (Result<Data>) -> Void) {
        let task = session.dataTask(with: url) { data, _, error in
            if let imageData = data {
                DispatchQueue.main.async {
                    completion(.success(imageData))
                }
            } else if let downloadError = error {
                completion(.failure(downloadError))
            }
        }
        task.resume()
        imageDownloadOperations[pokeId] = task
    }

    func cancelDownloadImage(_ pokeId: Int) {
        if let task = imageDownloadOperations[pokeId] {
            task.cancel()
        }
    }
}

class NetworkManager {
    private let session: URLSession
    private let router: Router<PokemonAPI>
    private let imageHandler: ImageHandler
    static let environment: NetworkEnvironment = .production

    init(session: URLSession = .shared) {
        self.session = session
        router = Router<PokemonAPI>(session: session)
        imageHandler = ImageHandler(session: session)
    }

    private func apiRequest<T>(_ pokemonAPI: PokemonAPI, handler completion: @escaping (APIResponse<T>) -> Void) {
        router.request(pokemonAPI) { data, response, error in
            if let failedRequest = error {
                completion(.failure(failedRequest))
            }

            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(.failure(NetworkResponseError.error("No response data")))
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(T.self, from: responseData)
                        completion(.success(apiResponse))
                    } catch {
                        completion(.failure(NetworkResponseError.error("Unable to decode data")))
                    }
                case let .failure(networkFailureError):
                    completion(.failure(NetworkResponseError.error(networkFailureError)))
                }
            }
        }
    }

    func getPokemon(completion: @escaping (APIResponse<PokemonSummaryResult>) -> Void) {
        apiRequest(.all, handler: completion)
    }

    func getIndividualPokemon(_ pokeId: Int, _ completion: @escaping (APIResponse<Pokemon>) -> Void) {
        apiRequest(.individual(pokeId: pokeId), handler: completion)
    }

    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkResult<String> {
        switch response.statusCode {
        case 200 ... 299: return .success
        case 401 ... 500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501 ... 599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }

    func downloadImage(_ url: URL, _ pokeId: Int, completion: @escaping (Result<Data>) -> Void) {
        imageHandler.downloadImage(url, pokeId) { result in
            completion(result)
        }
    }

    func cancelDownloadImage(_ pokeId: Int) {
        imageHandler.cancelDownloadImage(pokeId)
    }
}
