//
//  PokedexList.swift
//  Pokedex
//
//  Created by Zayaan Ali on 6/13/24.
//

import SwiftUI

struct PokedexList: View {
    @State private var pokeDex: [PokemonEntry] = []
    @State private var currentPage: Int = 0
    @State private var canLoadMore: Bool = true
    @State var searchText: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    
    /* Filtered list of Pokemon (based on search text) */
    var filteredPokedex: [PokemonEntry] {
        searchText.isEmpty ? pokeDex : pokeDex.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    /* Pokedex List View */
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredPokedex) { entry in
                    PokemonRow(entry: entry)
                        .listRowBackground(
                            Capsule()
                                .fill(Color.gray.opacity(0.1))
                                .padding(.vertical, 4)
                        )
                }
                .listRowSeparator(.hidden)
                
                // Load more pokemon
                if canLoadMore {
                    Button(action: {
                        currentPage += 1
                        fetchPokeDex()
                    }, label: {
                        Text("Load More")
                            .foregroundColor(.blue)
                            
                    })
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                } else {
                    Text("No more Pokemon to load.")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .navigationBarTitle("Pokedex")
            .searchable(text: $searchText)
            .listRowInsets(.init(top:0, leading: 40, bottom: 0, trailing: 40))
        }
        .onAppear {
            loadPokeDex()
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    /* Attempts to get data from cache. If not found then access API */
    private func loadPokeDex() {
        if let cachedPokedex = UserDefaults.standard.data(forKey: "pokeDex"),
           let decodedPokedex = try? JSONDecoder().decode([PokemonEntry].self, from: cachedPokedex) {
            self.pokeDex = decodedPokedex
        }
        
        // Always fetch fresh data if cache is empty or outdated
        fetchPokeDex()
    }
    
    
    /* Helper function to fetch API data */
    private func fetchPokeDex() {
        Task {
            do {
                let limit = 20  // Number of entries per page
                let offset = currentPage * limit
                
                let fetchedPokedex = try await PokeAPI().fetchPokemon(limit: limit, offset: offset)
                
                // If fetching the first page, clear existing data
                if currentPage == 0 {
                    self.pokeDex = fetchedPokedex
                } else {
                    self.pokeDex.append(contentsOf: fetchedPokedex)
                }
                
                if fetchedPokedex.isEmpty {
                    self.canLoadMore = false  // No more data to load
                }
                
                cachePokeDex(pokeDex: self.pokeDex)
            } catch {
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
        }
    }
    
    /* Helper function that caches PokeDex data*/
    private func cachePokeDex(pokeDex: [PokemonEntry]) {
        if let encodedPokedex = try? JSONEncoder().encode(pokeDex) {
            UserDefaults.standard.set(encodedPokedex, forKey: "pokeDex")
        }
    }
}

#Preview {
    PokedexList()
}
