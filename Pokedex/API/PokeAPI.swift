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

class PokeAPI {
    func fetchPokemon () async throws -> [PokemonEntry] {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=1302")!

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









