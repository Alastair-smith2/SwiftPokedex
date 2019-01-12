//
//  PokemonDetailView.swift
//  Pokdex
//
//  Created by Alastair Smith on 20/11/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//

import UIKit

class PokemonDetailView: UIStackView {
    fileprivate var regularConstraints = [NSLayoutConstraint]()
    fileprivate var compactConstraints = [NSLayoutConstraint]()

    lazy var headerView: PokemonDetailHeader = {
        let stack = PokemonDetailHeader()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 12
        return stack
    }()

    lazy var abilitiesView: PokemonDetailAbilities = {
        let stack = PokemonDetailAbilities()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 12
        return stack
    }()

    lazy var statsView: PokemonDetailStats = {
        let stack = PokemonDetailStats()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
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
        addArrangedSubview(headerView)
        addArrangedSubview(abilitiesView)
        addArrangedSubview(statsView)
        addRegularConstraints()
        addCompactConstaints()
        setNeedsUpdateConstraints()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.horizontalSizeClass == .regular {
            updateChildStackViews(.horizontal, .vertical, 40)
            NSLayoutConstraint.deactivate(regularConstraints)
            NSLayoutConstraint.activate(compactConstraints)
        } else {
            updateChildStackViews(.vertical, .horizontal, 40)
            NSLayoutConstraint.deactivate(compactConstraints)
            NSLayoutConstraint.activate(regularConstraints)
        }
    }

    func updateChildStackViews(_ parentAxis: NSLayoutConstraint.Axis, _ childAxis: NSLayoutConstraint.Axis, _ constant: CGFloat) {
        statsView.pokemonStatStackView.axis = parentAxis
        headerView.axis = parentAxis
        headerView.distribution = parentAxis == .vertical ? .fill : .fillEqually
        headerView.pokemonType.axis = childAxis
        for child in statsView.pokemonStatStackView.arrangedSubviews {
            if let childStack = child as? UIStackView {
                childStack.axis = childAxis
            }
        }
        updateChildLabels(headerView.pokemonType.arrangedSubviews + abilitiesView.pokemonAbilityStackView.arrangedSubviews, constant)
    }

    func updateChildLabels(_ views: [UIView], _ constant: CGFloat) {
        for view in views {
            if let typeLabel = view as? UILabel {
                NSLayoutConstraint.deactivate(typeLabel.constraints)
                typeLabel.heightAnchor.constraint(equalToConstant: constant).isActive = true
            }
        }
    }

    func addCompactConstaints() {
        let compactConstraintList = [
            self.headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),

            self.abilitiesView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.abilitiesView.leadingAnchor.constraint(equalTo: self.leadingAnchor),

            self.statsView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.statsView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        ]
        for constraint in compactConstraintList {
            compactConstraints.append(constraint)
        }
    }

    func addRegularConstraints() {
        let regularConstraintList = [
            self.headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),

            self.abilitiesView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.abilitiesView.leadingAnchor.constraint(equalTo: self.leadingAnchor),

            self.statsView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.statsView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.statsView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.50),
        ]

        for constraint in regularConstraintList {
            regularConstraints.append(constraint)
        }
    }
}
