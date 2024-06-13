//
//  PokeAPI.swift
//  Pokedex-testapp
//
//  Created by Zayaan Ali on 6/10/24.
//

import Foundation

struct Pokemon : Codable {
    var results : [PokemonEntry]
}

struct PokemonEntry : Codable, Identifiable {
    let name : String
    let url : String // url for the individual pokemon
    let id = UUID()
}

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

class PokeAPI {
    func fetchPokemon (limit: Int, offset: Int) async throws -> [PokemonEntry] {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)")!

        let (data, _) = try await URLSession.shared.data(from: url)
        let pokemonList = try JSONDecoder().decode(Pokemon.self, from: data)
        
        return pokemonList.results
    }
        
    func fetchPokemonDetails(url: String) async throws -> PokemonDetails {
        let url = URL(string: url)!
        let (data, _) = try await URLSession.shared.data(from: url)
        let pokemonDetail = try JSONDecoder().decode(PokemonDetails.self, from: data)
        
        return pokemonDetail
    }


}


