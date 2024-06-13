//
//  PokemonRow.swift
//  Pokedex-testapp
//
//  Created by Zayaan Ali on 6/10/24.
//

import Foundation
import SwiftUI
  
import SwiftUI

struct PokemonRow: View {
    let entry: PokemonEntry
    @State private var pokemonDetails: PokemonDetails?
    @State private var pokemonSprite: Image?
    @State private var isFetchingDetails = false
    
    // Cache to store fetched PokemonDetails and sprites
    @State private var detailsCache: [String: (details: PokemonDetails, sprite: Image)] = [:]

    var body: some View {
        HStack {
            if let details = pokemonDetails, let img = pokemonSprite {
                NavigationLink(destination: PokemonDetailView(pokemonEntry: details, pokemonSprite: img)) {
                    displayPokemonSprite()
                    Text(entry.name.capitalized)
                }
            } else {
                Text("Loading")
            }
        }
        .onAppear {
            fetchPokemonDetailsIfNeeded()
        }
    }

    private func displayPokemonSprite() -> some View {
        if let sprite = pokemonSprite {
            return AnyView(
                sprite
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            )
        } else {
            return AnyView(
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
            )
        }
    }
    
    private func fetchPokemonDetailsIfNeeded() {
        // Check if details are already fetched and cached
        if let cachedDetails = detailsCache[entry.url] {
            pokemonDetails = cachedDetails.details
            pokemonSprite = cachedDetails.sprite
        } else {
            fetchPokemonDetails() // If details are not cached, fetch them
        }
    }
    
    private func fetchPokemonDetails() {
        guard !isFetchingDetails else { return } // Prevent multiple fetches
        isFetchingDetails = true
        
        Task {
            do {
                let details = try await PokeAPI().fetchPokemonDetails(url: entry.url)
                pokemonDetails = details
                
                // Check if sprite is already cached
                if let cachedSprite = detailsCache[entry.url]?.sprite {
                    pokemonSprite = cachedSprite
                } else if let frontDefaultURL = details.sprites.front_default {
                    let sprite = try await fetchPokemonSprite(url: frontDefaultURL)
                    pokemonSprite = Image(uiImage: sprite)
                    
                    // Cache both details and sprite
                    detailsCache[entry.url] = (details, pokemonSprite!)
                }
                
            } catch {
                print("Error fetching pokemon details:", error)
            }
            isFetchingDetails = false
        }
    }
    
    private func fetchPokemonSprite(url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw FetchError.invalidImageData
        }
        return image
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
