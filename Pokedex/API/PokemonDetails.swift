//
//  PokemonDetails.swift
//  Pokedex
//
//  Created by Zayaan Ali on 6/13/24.
//

import Foundation

struct PokemonDetails : Codable {
    let id : Int
    let name : String
    let sprites : PokemonSprite
    let types : [PokemonTypes]
    let height : Int
    let weight : Int
    let stats : [PokemonStatEntry]
}

struct PokemonSprite : Codable {
    let front_default : URL?
}

struct PokemonTypes : Codable {
    let type : PokemonType
}

struct PokemonType : Codable {
    let name : String
}
