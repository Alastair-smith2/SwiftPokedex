//
//  PokemonModel.swift
//  Pokdex
//
//  Created by Alastair Smith on 25/10/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Pokemon: Object, Decodable {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var sprites: Sprites?
    @objc dynamic var image: Data?
    var types = List<PokemonType>()
    var abilities = List<PokemonAbility>()
    var stats = List<PokemonStat>()

    override static func primaryKey() -> String? {
        return "name"
    }

    override static func indexedProperties() -> [String] {
        return ["id"]
    }

    convenience init(id: Int,
                     name: String,
                     sprites: Sprites,
                     types: List<PokemonType>,
                     abilities: List<PokemonAbility>,
                     stats: List<PokemonStat>) {
        self.init()
        self.id = id
        self.name = name
        self.sprites = sprites
        self.types = types
        self.abilities = abilities
        self.stats = stats
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonCodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let sprites = try container.decode(Sprites.self, forKey: .sprites)
        let types = try container.decode([PokemonType].self, forKey: .types)
        var typeList = List<PokemonType>()
        typeList.append(objectsIn: types)
        typeList.reverse()
        let abilities = try container.decode([PokemonAbility].self, forKey: .abilities)
        var abilitiyList = List<PokemonAbility>()
        abilitiyList.append(objectsIn: abilities)
        abilitiyList.reverse()
        let stats = try container.decode([PokemonStat].self, forKey: .stats)
        var statList = List<PokemonStat>()
        statList.append(objectsIn: stats)
        statList.reverse()
        self.init(id: id, name: name, sprites: sprites, types: typeList, abilities: abilitiyList, stats: statList)
    }

    private enum PokemonCodingKeys: String, CodingKey {
        case id
        case name
        case sprites
        case types
        case abilities
        case stats
    }
}

class Sprites: Object, Decodable {
    @objc dynamic var sprite: String = ""

    private enum SpriteCodingKeys: String, CodingKey {
        case sprite = "front_default"
    }

    convenience init(sprite: String) {
        self.init()
        self.sprite = sprite
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SpriteCodingKeys.self)
        let sprite = try container.decode(String.self, forKey: .sprite)
        self.init(sprite: sprite)
    }

    required init() {
        super.init()
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}

class PokemonType: Object, Decodable {
    @objc dynamic var slot: Int = 0
    @objc dynamic var type: PropertyName?

    private enum PokemonTypeKeys: String, CodingKey {
        case slot
        case type
    }

    convenience init(slot: Int, type: PropertyName) {
        self.init()
        self.slot = slot
        self.type = type
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonTypeKeys.self)
        let slot = try container.decode(Int.self, forKey: .slot)
        let type = try container.decode(PropertyName.self, forKey: .type)
        self.init(slot: slot, type: type)
    }

    required init() {
        super.init()
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}

class PokemonAbility: Object, Decodable {
    @objc dynamic var slot: Int = 0
    @objc dynamic var is_hidden: Bool = false
    @objc dynamic var ability: PropertyName?

    private enum PokemonTypeKeys: String, CodingKey {
        case slot
        case is_hidden
        case ability
    }

    convenience init(slot: Int, is_hidden: Bool, ability: PropertyName) {
        self.init()
        self.slot = slot
        self.is_hidden = is_hidden
        self.ability = ability
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonTypeKeys.self)
        let slot = try container.decode(Int.self, forKey: .slot)
        let is_hidden = try container.decode(Bool.self, forKey: .is_hidden)
        let ability = try container.decode(PropertyName.self, forKey: .ability)
        self.init(slot: slot, is_hidden: is_hidden, ability: ability)
    }

    required init() {
        super.init()
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}

class PokemonStat: Object, Decodable {
    @objc dynamic var stat: PropertyName?
    @objc dynamic var base_stat: Int = 0

    private enum PokemonTypeKeys: String, CodingKey {
        case stat
        case base_stat
    }

    convenience init(stat: PropertyName, base_stat: Int) {
        self.init()
        self.stat = stat
        self.base_stat = base_stat
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonTypeKeys.self)
        let stat = try container.decode(PropertyName.self, forKey: .stat)
        let base_stat = try container.decode(Int.self, forKey: .base_stat)
        self.init(stat: stat, base_stat: base_stat)
    }

    required init() {
        super.init()
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}

class PropertyName: Object, Decodable {
    @objc dynamic var name: String = ""

    private enum BaseTypeKeys: String, CodingKey {
        case name
    }

    convenience init(name: String) {
        self.init()
        self.name = name
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: BaseTypeKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        self.init(name: name)
    }

    required init() {
        super.init()
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}

class ActivePokemon: Object {
    @objc dynamic var selectedPokemon: Pokemon?
    @objc dynamic var id = 0

    override static func primaryKey() -> String? {
        return "id"
    }

    required init() {
        super.init()
    }

    convenience init(pokemon: Pokemon) {
        self.init()
        selectedPokemon = pokemon
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}
