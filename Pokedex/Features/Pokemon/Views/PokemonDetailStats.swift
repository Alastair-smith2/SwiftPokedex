//
//  PokemonDetailStats.swift
//  Pokedex
//
//  Created by Alastair Smith on 11/12/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//

import UIKit

class PokemonDetailStats: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    lazy var pokemonStatsTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    lazy var pokemonStatStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 8
        return stack
    }()

    func setupView() {
        addArrangedSubview(pokemonStatsTitle)
        addArrangedSubview(pokemonStatStackView)
    }
}
