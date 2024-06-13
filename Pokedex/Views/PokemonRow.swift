//
//  PokemonRow.swift
//  Pokedex-testapp
//
//  Created by Zayaan Ali on 6/10/24.
//

import Foundation
import SwiftUI
  
struct PokemonRow: View {
    let entry: PokemonEntry
    @State private var pokemonDetails: PokemonDetails?

    var body: some View {
        let pokemonFirstType = pokemonDetails?.types.first?.type.name
        HStack {
            
            if let details = pokemonDetails {
                NavigationLink(destination: PokemonDetailView(pokemonEntry: details)) {
                    displayPokemonSprite()
                    Text(entry.name.capitalized)
                }
            } else {
                Text("Loading")
            }
    
        }
        .onAppear {
            fetchPokemonDetails()
        }
        
    }

    private func displayPokemonSprite() -> some View {
        if let frontDefaultURL = pokemonDetails?.sprites.front_default {
            return AnyView(
                AsyncImage(url: frontDefaultURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                } placeholder: {
                    ProgressView()
                }
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)

            )
        } else {
            return AnyView(
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
            )
        }
    }
    
    private func fetchPokemonDetails() {
        Task {
            do {
                let details = try await PokeAPI().fetchPokemonDetails(url: entry.url)
                pokemonDetails = details
            } catch {
                print(error)
            }
        }
    }
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func pokemonBackgroundColor (for type: String?) -> Color {
    switch type {
        case "fire":
            return Color.red.opacity(0.6)
        case "water":
            return Color.blue.opacity(0.6)
        case "grass":
            return Color.green.opacity(0.6)
        case "electric":
            return Color.yellow.opacity(0.6)
        case "psychic":
            return Color.purple.opacity(0.6)
        case "ice":
            return Color.cyan.opacity(0.6)
        case "dragon":
            return Color.orange.opacity(0.6)
        case "dark":
            return Color.black.opacity(0.6)
        case "fairy":
            return Color.pink.opacity(0.6)
        default:
            return Color.gray.opacity(0.6)
    }
}
