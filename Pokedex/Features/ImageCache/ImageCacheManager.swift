//
//  ImageCacheManager.swift
//  Pokedex
//
//  Created by Alastair Smith on 29/12/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//

import Foundation
import UIKit

struct ImageCacheManager {
    func cacheImage(_ pokemonId: Int, _ image: UIImage) {
        imageCache.setObject(image, forKey: pokemonId as AnyObject)
    }

    func getCachedImage(_ pokemonId: Int) -> UIImage? {
        return imageCache.object(forKey: pokemonId as AnyObject)
    }
}
