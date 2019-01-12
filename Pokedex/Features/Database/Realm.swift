//
//  Realm.swift
//  Pokdex
//
//  Created by Alastair Smith on 01/11/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

enum Result<T> {
    case success(T)
    case failure(Error)
}

class RealmHelper {
    func loadSelected() -> Results<ActivePokemon> {
        return withRealm { realm in
            realm.objects(ActivePokemon.self)
        }
    }

    func loadPokemon() -> Results<Pokemon> {
        return withRealm { realm in
            realm.objects(Pokemon.self).sorted(byKeyPath: "id")
        }
    }

    func save(_ realmObject: Object, update: Bool = true) {
        withRealm { realm in
            try? realm.write { realm.add(realmObject, update: update) }
        }
    }

    func save(_ objects: [Object], update: Bool = true) {
        withRealm { realm in
            try? realm.write { realm.add(objects, update: update) }
        }
    }

    func deleteRealm() {
        withRealm { realm in
            try? realm.write { realm.deleteAll() }
        }
    }

    fileprivate func withRealm<T>(_ closure: (Realm) throws -> T) -> T {
        do {
            let realm = try Realm()
            return try closure(realm)
        } catch {
            print("Fatal Realm error")
            fatalError()
        }
    }
}
