//
//  ContentView.swift
//  Pokedex-testapp
//
//  Created by Zayaan Ali on 6/10/24.
//

import SwiftUI



struct ContentView: View {
    
    @State private var pokeDex : [PokemonEntry] = []
    @State var searchText: String = ""
    
    
    var filteredPokedex: [PokemonEntry] {
        if searchText.isEmpty {
            return pokeDex
        } else {
            return pokeDex.filter {
                ($0.name.lowercased().contains(searchText.lowercased()))
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredPokedex) { entry in
                    HStack {
                        PokemonRow(entry: entry)
                    }.listRowBackground(
                        Capsule()
                            .fill(Color.gray.opacity(0.1))
                            .padding(.vertical, 4)
                    
                    )
                }
                .listRowSeparator(.hidden)
                
            }
            .navigationBarTitle("Pokedex")
            .searchable(text: $searchText)
            .listRowInsets(.init(top:0, leading: 40, bottom: 0, trailing: 40))
        }
        .onAppear {
            fetchPokeDex()
        }
    }
    
    private func fetchPokeDex() {
        Task {
            do {
                pokeDex = try await PokeAPI().fetchPokemon()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    ContentView()
}


