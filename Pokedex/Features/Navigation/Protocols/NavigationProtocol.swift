//
//  NavigationProtocol.swift
//  Pokdex
//
//  Created by Alastair Smith on 19/10/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
}

protocol Navigator {
    func navigate(to destination: Screens)
    func makeViewController(for destination: Screens) -> UIViewController
}
