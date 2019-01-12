//
//  PokemonDetailViewController.swift
//  Pokdex
//
//  Created by Alastair Smith on 20/11/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    private lazy var detailView: PokemonDetailView = {
        let stack = PokemonDetailView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 20
        stack.accessibilityIdentifier = "detailView"
        return stack
    }()

    private let coordinator: MainCoordinator
    private let controller: PokemonDetailModelController

    fileprivate var regularConstraints = [NSLayoutConstraint]()
    fileprivate var compactConstraints = [NSLayoutConstraint]()

    init(coordinator: MainCoordinator,
         controller: PokemonDetailModelController) {
        self.coordinator = coordinator
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(false, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(detailView)
        if let selectedPokemon = controller.loadSelectedPokemon() {
            setupScreen(selectedPokemon)
        }
    }

    func setupScreen(_ selectedPokemon: Pokemon) {
        title = "\(selectedPokemon.name.capitalized) - \(selectedPokemon.id)"

        if let imageData = controller.getCachedImage(selectedPokemon.id) {
            detailView.headerView.pokemonImage.image = imageData
        }

        for baseType in selectedPokemon.types {
            if let typeExists = baseType.type {
                let label = generateLabel(typeExists.name)
                if let backgroundColor = ColourTheme(rawValue: typeExists.name) {
                    label.backgroundColor = backgroundColor.color
                }
                detailView.headerView.pokemonType.addArrangedSubview(label)
            }
        }

        detailView.statsView.pokemonStatsTitle.text = "Base stats"
        for baseStat in selectedPokemon.stats {
            if let statExists = baseStat.stat {
                let stack = generateStackView(.horizontal, spacing: 5, alignment: .fill, distribution: .fillEqually)
                let labelTitle = generateLabel(statExists.name)
                let statLabel = generateLabel("\(baseStat.base_stat)")
                stack.addArrangedSubview(labelTitle)
                stack.addArrangedSubview(statLabel)
                detailView.statsView.pokemonStatStackView.addArrangedSubview(stack)
            }
        }

        detailView.abilitiesView.pokemonAbilityTitle.text = "Ability"
        for pokemonAbility in selectedPokemon.abilities {
            if let abilityExists = pokemonAbility.ability {
                let label = generateLabel(abilityExists.name)
                detailView.abilitiesView.pokemonAbilityStackView.addArrangedSubview(label)
            }
        }

        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            detailView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            detailView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            detailView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor),
        ])
        view.setNeedsUpdateConstraints()
    }

    func generateLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 20
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.text = text.capitalized
        label.accessibilityIdentifier = text
        return label
    }

    func generateStackView(_ type: NSLayoutConstraint.Axis,
                           spacing: CGFloat,
                           alignment: UIStackView.Alignment,
                           distribution: UIStackView.Distribution) -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = type
        stack.distribution = distribution
        stack.alignment = alignment
        stack.spacing = spacing
        return stack
    }

    @objc func test() {
        coordinator.navigationController.popViewController(animated: true)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
