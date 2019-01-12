//
//  MainCoordinator.swift
//  Pokedex
//
//  Created by Alastair Smith on 23/10/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension MainCoordinator: Navigator {
    func navigate(to destination: Screens) {
        let viewController = makeViewController(for: destination)
        navigationController.pushViewController(viewController, animated: true)
    }

    internal func makeViewController(for destination: Screens) -> UIViewController {
        switch destination {
        case .auth:
            let authVc = AuthViewController.instantiate("Auth")
            authVc.coordinator = self
            authVc.userController = addUserController()
            return authVc
        case .home:
            let tableViewController = PokemonTableViewController.instantiate("Main")
            tableViewController.coordinator = self
            tableViewController.pokemonController = addPokemonModelController()
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.setNavigationBarHidden(false, animated: true)
            return tableViewController
        case .detail:
            let modelController = addPokemonDetailModelController()
            let detailController = PokemonDetailViewController(coordinator: self, controller: modelController)
            navigationController.setNavigationBarHidden(false, animated: true)
            return detailController
        }
    }
}

// Could separate these out into factory method
extension MainCoordinator: ModelControlerInjector {
    func addUserController() -> UserModelController {
        let initialUser = User(userName: "", validated: false)
        let userModelController = UserModelController(user: initialUser)
        return userModelController
    }

    func addPokemonModelController() -> PokemonModelController {
        let networkService = NetworkManager()
        let realmHelper = RealmHelper()
        let imageCacheManager = ImageCacheManager()
        let pokemonModelController = PokemonModelController(
            networkService: networkService,
            realmHelper: realmHelper,
            imageManager: imageCacheManager
        )
        return pokemonModelController
    }

    func addPokemonDetailModelController() -> PokemonDetailModelController {
        let imageCacheManager = ImageCacheManager()
        let realmHelper = RealmHelper()
        let controller = PokemonDetailModelController(imageManager: imageCacheManager, realmHelper: realmHelper)
        return controller
    }
}

enum Screens {
    case auth
    case home
    case detail
}
