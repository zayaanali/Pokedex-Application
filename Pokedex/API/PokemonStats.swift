//
//  PokemonStats.swift
//  Pokedex
//
//  Created by Zayaan Ali on 6/13/24.
//

import Foundation

struct PokemonStatEntry : Codable, Identifiable {
    var id = UUID()
    let base_stat: Int
    let stat: PokemonStat

    private enum CodingKeys: String, CodingKey {
        case base_stat
        case stat
    }
}

struct PokemonStat : Codable {
    let name: String
}
