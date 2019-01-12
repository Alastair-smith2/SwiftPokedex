//
//  ChampionsTableViewController.swift
//  Pokdex
//
//  Created by Alastair Smith on 19/10/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//

import RealmSwift
import UIKit

class PokemonTableViewController: UITableViewController, Storyboarded {
    var pokemonController: PokemonModelController?
    weak var coordinator: MainCoordinator?
    var notificationToken: NotificationToken?
    var activityIndicatorView: UIActivityIndicatorView!
    var searchController: UISearchController = UISearchController(searchResultsController: nil)

    override func loadView() {
        super.loadView()

        activityIndicatorView = UIActivityIndicatorView(style: .gray)

        tableView.backgroundView = activityIndicatorView
//        title = "Pokedex"
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.title = "Pokedex"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        navigationItem.searchController = searchController
        activityIndicatorView.startAnimating()
        tableView.separatorStyle = .none

        pokemonController?.setUpTable { resultStatus in
            switch resultStatus {
            case true:
                self.notificationToken = self.pokemonController?.displayedResults?.observe { [weak self] (changes: RealmCollectionChange) in
                    guard let tableView = self?.tableView else { return }
                    switch changes {
                    case .initial:
                        // Results are now populated and can be accessed without blocking the UI
                        self?.activityIndicatorView.stopAnimating()
                        self?.tableView.separatorStyle = .singleLine
                        tableView.reloadData()
                    case let .update(_, deletions, insertions, modifications):
                        // Query results have changed, so apply them to the UITableView
                        tableView.beginUpdates()
                        tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                             with: .automatic)
                        tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }),
                                             with: .automatic)
                        tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                             with: .automatic)
                        tableView.endUpdates()
                    case .error:
                        self?.activityIndicatorView.stopAnimating()
                    }
                }
            case false:
                self.activityIndicatorView.stopAnimating()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return pokemonController?.displayedResults?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokecell", for: indexPath) as! PokemonTableViewCell
        guard let pokemon = pokemonController?.displayedResults?[indexPath.row] else {
            return cell
        }
        cell.pokemonNumber.text = "#\(pokemon.id)"
        cell.pokemonTitle.text = pokemon.name.capitalized
        cell.pokemonImage.image = pokemonController?.getCachedImage(pokemon.id) ?? nil
        cell.accessibilityIdentifier = "\(pokemon.name)"
        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let pokemonId = pokemonController?.displayedResults?[indexPath.row].id {
            pokemonController?.setActivePokemon(pokemonId) { pokemonSet in
                if pokemonSet == true {
                    self.coordinator?.navigate(to: .detail)
                }
            }
        }
    }

    override func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard (pokemonController?.displayedResults?.count ?? 0 > indexPath.row) == true else {
            return
        }

        guard let pokemonId: Int = pokemonController?.displayedResults?[indexPath.row].id,
            pokemonController?.getCachedImage(pokemonId)
            == nil else {
            return
        }

        if let imageURL = pokemonController?.displayedResults?[indexPath.row].sprites?.sprite,
            let url = URL(string: imageURL) {
            pokemonController?.downloadImage(url, pokemonId) { imageResult in
                switch imageResult {
                case let .success(imageData):
                    self.setImage(indexPath, pokemonId, imageData)
                case .failure:
                    self.setImage(indexPath, pokemonId, nil)
                }
            }
        }
    }

    func setImage(_ indexPath: IndexPath, _ pokeId: Int, _ data: Data?) {
        DispatchQueue.main.async {
            if let cellToUpdate = self.tableView.cellForRow(at: indexPath),
                cellToUpdate.imageView?.image == nil,
                let image = data, let pokeImage = UIImage(data: image) {
                if let pokeCell = cellToUpdate as? PokemonTableViewCell {
                    pokeCell.pokemonImage.image = pokeImage
                    pokeCell.pokemonImage.alpha = 0
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
                        pokeCell.pokemonImage.alpha = 1
                    }, completion: nil)
                    self.pokemonController?.cacheImage((pokeId, pokeImage))
                }
            }
        }
    }

    override func tableView(_: UITableView, didEndDisplaying _: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard (pokemonController?.displayedResults?.count ?? 0 > indexPath.row) == true else {
            return
        }
        guard let pokeId: Int = pokemonController?.displayedResults?[indexPath.row].id else {
            return
        }

        pokemonController?.cancelImageDownload(pokeId)
    }

    deinit {
        notificationToken?.invalidate()
    }
}

extension PokemonTableViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_: UISearchBar) {
        pokemonController?.endSearch()
        tableView.reloadData()
    }
}

extension PokemonTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchController.isActive {
            pokemonController?.filterContent(for: searchText)
            tableView.reloadData()
        }
    }
}
