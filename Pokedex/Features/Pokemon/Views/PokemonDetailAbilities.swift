//
//  PokemonDetailAbilities.swift
//  Pokedex
//
//  Created by Alastair Smith on 11/12/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//

import UIKit

class PokemonDetailAbilities: UIStackView {
    lazy var pokemonAbilityTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    lazy var pokemonAbilityStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 12
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        addArrangedSubview(pokemonAbilityTitle)
        addArrangedSubview(pokemonAbilityStackView)
    }
}
