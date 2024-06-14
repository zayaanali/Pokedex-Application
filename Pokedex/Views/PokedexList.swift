//
//  PokedexList.swift
//  Pokedex
//
//  Created by Zayaan Ali on 6/13/24.
//

import SwiftUI

struct PokedexList: View {
    @State var pokeDex: [PokemonEntry] = []
    @State private var currentPage: Int = 0
    @State private var canLoadMore: Bool = true
    @State var searchText: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    
    /* Filtered list of Pokemon (based on search text) */
    var filteredPokedex: [PokemonEntry] {
        if searchText.isEmpty {
            let startIndex = currentPage * 20
            let endIndex = min((currentPage + 1) * 20, pokeDex.count)
            return Array(pokeDex[startIndex..<endIndex])
        } else {
            return pokeDex.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
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
                if currentPage < 65 {
                    HStack {
                        Button(action: {
                            currentPage -= 1
                            fetchPokeDex()
                        }, label: {
                            Text("Previous Page")
                                .foregroundColor(.blue)
                            
                        })
                        .buttonStyle(PlainButtonStyle())
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        
                        Button(action: {
                            currentPage += 1
                            fetchPokeDex()
                        }, label: {
                            Text("Next Page")
                                .foregroundColor(.blue)
                                
                        })
                        .buttonStyle(PlainButtonStyle())
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
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
            fetchPokeDex()
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    /* Helper function to fetch API data */
    func fetchPokeDex() {
        Task {
            do {
                pokeDex = try await PokeAPI().fetchPokemon()
            } catch {
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
        }
    }
}

#Preview {
    PokedexList()
}
