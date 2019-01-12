//
//  UserModelController.swift
//  Pokdex
//
//  Created by Alastair Smith on 19/10/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//

import Foundation
import RealmSwift

protocol UserModelValidation {
    var passwordLength: Int { get }
}

let minPasswordCharacterLength = 8

class UserModelController {
    private var user: User

    init(user: User) {
        self.user = user
    }
}

extension UserModelController {
    func handleAuth(_ name: String, _ password: String, closure: @escaping (FakeAuthReponse) -> Void) {
        if password == "helloworld" {
            user.userName = name
            user.validated = true
            closure(.success)
        } else {
            user.validated = false
            closure(.failure)
        }
    }
}

extension UserModelController {
    var userName: String {
        return user.userName
    }
}

extension UserModelController: UserModelValidation {
    var passwordLength: Int {
        return minPasswordCharacterLength
    }
}

enum FakeAuthReponse {
    case success
    case failure
}
