//
//  PokemonTableViewCell.swift
//  Pokdex
//
//  Created by Alastair Smith on 01/11/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    @IBOutlet var pokemonNumber: UILabel!

    @IBOutlet var pokemonImage: UIImageView!

    @IBOutlet var pokemonTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
