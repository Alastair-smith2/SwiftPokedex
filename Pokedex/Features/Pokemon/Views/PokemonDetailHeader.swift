//
//  PokemonDetailHeader.swift
//  Pokedex
//
//  Created by Alastair Smith on 12/12/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//

import UIKit

class PokemonDetailHeader: UIStackView {
    lazy var pokemonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.accessibilityIdentifier = "pokemonImage"
        return imageView
    }()

    lazy var pokemonType: PokemonDetailType = {
        let stack = PokemonDetailType()
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
        addArrangedSubview(pokemonImage)
        addArrangedSubview(pokemonType)
    }
}
