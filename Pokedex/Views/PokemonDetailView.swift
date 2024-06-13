import SwiftUI
import Charts

struct PokemonDetailView: View {
    var pokemonEntry: PokemonDetails

    var body: some View {
        ScrollView {
            // save background color for theming
            let pokemonBgrdColor = pokemonBackgroundColor(for: pokemonEntry.types.first?.type.name)
            
            ZStack {
                /* Sprite Background */
                Rectangle()
                    .fill(pokemonBgrdColor)
                    .frame(height: 300)
                    .cornerRadius(10)

                VStack {
                    displayPokemonSprite()
                    
                    HStack {
                        Text(pokemonEntry.name.capitalized)
                            .font(.title)
                            .bold()
                        
                        Spacer()
                        Text("#0\(pokemonEntry.id)")
                            .font(.title3)
                            .foregroundColor(.gray)
                        
                    }.padding(.horizontal, 20)
                }
            }
        
            /* Display Pokemon Name and id */
            
            
            /* Print Pokemon Types */
            HStack {
                ForEach(pokemonEntry.types, id: \.type.name) { pokemonType in
                    Rectangle()
                        .fill(pokemonBackgroundColor(for: pokemonType.type.name))
                        .frame(width: 75, height: 35)
                        .cornerRadius(10)
                        .overlay (
                            Text(pokemonType.type.name.capitalized)
                                .foregroundColor(Color.white)
                                .font(.footnote)
                                .bold()
                                .scaledToFit()
                                .shadow(radius: 1)
                        )
                }
            }
            
            /* Pokemon Basic Information */
            
            // Convert height/weight to correct units
            let (convertedFeet, convertedInches) = convertHeight(decameters: pokemonEntry.height)
            let convertedWeight = convertWeight(decagrams: pokemonEntry.weight)
            
            
                
            ZStack {
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: .continuous)
                    .frame(height: 100)
                    .foregroundColor(Color.white)
                    .shadow(radius: 1)
                    .padding(.horizontal, 1)
                    .overlay(
                        HStack {
                            VStack {
                                Text("Height")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                Text("'\(convertedFeet) \"\(convertedInches)" )
                            }
                            Divider()
                                .frame(width: 1)
                                .padding(.horizontal, 25)
                                .padding(.vertical, 20)

                            VStack {
                                Text("Weight")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                Text("\(convertedWeight) lbs")
                            }
                        }.padding(.all, 10)
                    )
                    .offset(x: 0, y: 0)
                
                Capsule() // Text Header
                    
                    .stroke(pokemonBgrdColor, lineWidth: 4)
                    .background(.white)
                    .frame(width: 140, height: 30)
                    .overlay(
                        Text("Basic Information")
                            .foregroundColor(pokemonBgrdColor)
                            .font(.system(size: 13))
                            .bold()
                    )
                    .cornerRadius(20)
                    .offset(x: 0, y: -50)
            }.padding(.vertical, 40)
            
            ZStack {
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: .continuous)
                    .frame(height: 225)
                    .foregroundColor(Color.white)
                    .shadow(radius: 1)
                    .padding(.horizontal, 1)
                    .overlay(
                        Chart {
                            ForEach(pokemonEntry.stats) { entry in
                                BarMark(x: .value("value", entry.base_stat),
                                        y: .value("type", shortenedStatName(statName: entry.stat.name))).foregroundStyle(pokemonBgrdColor.gradient)
                                    .cornerRadius(50)
                                    .annotation (position: .trailing) {
                                        Text("\(entry.base_stat)")
                                            .font(.system(size: 10))
                                            .foregroundColor(.gray)
                                    }
                            }
                        }
                            .padding(.horizontal, 25)
                            .padding(.vertical, 30)
                            .chartLegend(.hidden)
                            .chartXAxis(.hidden)
                            .chartYAxis {
                                AxisMarks { _ in
                                    AxisValueLabel()
                                }
                            }
                    )
                    .offset(x: 0, y: 0)

                
                Capsule() // Text Header
                    .stroke(pokemonBgrdColor, lineWidth: 4)
                    .background(.white)
                    .frame(width: 140, height: 30)
                    .overlay(
                        Text("Base Stats")
                            .foregroundColor(pokemonBgrdColor)
                            .font(.system(size: 13))
                            .bold()
                    )
                    .cornerRadius(20)
                    .offset(x: 0, y: -115)
            }
            
            
            
        }
        .padding(.horizontal, 40)
    }
        

    @ViewBuilder
    private func displayPokemonSprite() -> some View {
        if let frontDefaultURL = pokemonEntry.sprites.front_default {
            AsyncImage(url: frontDefaultURL) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 50)
            } placeholder: {
                ProgressView()
            }
            .clipShape(Circle())
        } else {
            Image(systemName: "questionmark.circle")
                .resizable()
                .frame(width: 50, height: 50)
        }
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let mockPokemonDetails = PokemonDetails(
            id: 25,
            name: "pikachu",
            sprites: PokemonSprite(front_default: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png")),
            types: [PokemonTypes(type: PokemonType(name: "electric")), PokemonTypes(type: PokemonType(name: "normal"))],
            height: 4,
            weight: 60,
            stats: [ PokemonStatEntry(base_stat: 35, stat: PokemonStat(name:          "hp")),
                     PokemonStatEntry(base_stat: 55, stat: PokemonStat(name: "attack")),
                     PokemonStatEntry(base_stat: 40, stat: PokemonStat(name: "defense")),
                     PokemonStatEntry(base_stat: 50, stat: PokemonStat(name: "special-attack")),
                     PokemonStatEntry(base_stat: 50, stat: PokemonStat(name: "special-defense")),
                     PokemonStatEntry(base_stat: 90, stat: PokemonStat(name: "speed")) ]
        )
        PokemonDetailView(pokemonEntry: mockPokemonDetails)
    }
}
