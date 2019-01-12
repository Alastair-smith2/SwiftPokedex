//
//  StoryboardProtocol.swift
//  Pokdex
//
//  Created by Alastair Smith on 20/10/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//

import Foundation
import UIKit

protocol Storyboarded {
    static func instantiate(_ storyboardName: String) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(_ storyboardName: String) -> Self {
        let fullName = NSStringFromClass(self)

        // this splits by the dot and uses everything after, giving "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]

        // load our storyboard
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)

        // instantiate a view controller with that identifier, and force cast as the type that was requested
        // swiftlint:disable force_cast
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}

extension Storyboarded where Self: UITableViewController {
    static func instantiate(_ storyboardName: String) -> Self {
        // this pulls out "MyApp.MyViewController"
        let fullName = NSStringFromClass(self)
        // this splits by the dot and uses everything after, giving "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]
        // load our storyboard
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        // instantiate a view controller with that identifier, and force cast as the type that was requested
        // swiftlint:disable force_cast
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}

extension UITabBarController {
    static func instantiate(_ storyboardName: String) -> UITabBarController {
        // this pulls out "MyApp.MyViewController"
        let fullName = NSStringFromClass(self)
        // load our storyboard
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)

        // instantiate a view controller with that identifier, and force cast as the type that was requested
        // swiftlint:disable force_cast
        return storyboard.instantiateViewController(withIdentifier: fullName) as! UITabBarController
    }
}
