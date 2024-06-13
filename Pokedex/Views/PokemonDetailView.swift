import SwiftUI
import Charts

struct PokemonDetailView: View {
    let pokemonEntry: PokemonDetails
    let pokemonSprite: Image
    
    

    var body: some View {
        /* Variables for readability */
        let pokemonBgrdColor = pokemonBackgroundColor(for: pokemonEntry.types.first?.type.name)
        let (convertedFeet, convertedInches) = convertHeight(decameters: pokemonEntry.height)
        let convertedWeight = convertWeight(decagrams: pokemonEntry.weight)
        
        ScrollView {
            /* Pokemon Header (sprite, name, id) */
            ZStack {
                RoundedRectangle(cornerRadius: 10) // background
                    .fill(pokemonBgrdColor)
                    .frame(height: 300)
                VStack { // sprite, name, and id
                    pokemonSprite
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 50)
                    HStack {
                        Text(pokemonEntry.name.capitalized)
                            .font(.title)
                            .bold()
                        Spacer()
                        Text("#0\(pokemonEntry.id)")
                            .font(.title3)
                    }.padding(.horizontal, 20)
                }
            }
        
            /* Print Pokemon Types */
            HStack {
                ForEach(pokemonEntry.types, id: \.type.name) { pokemonType in
                    RoundedRectangle(cornerRadius: 10)
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
            
            /* Pokemon Basic Information (height and weight) */
            ZStack {
                infoBox(title: "Basic Information", height: 100, offset: -50, color: pokemonBgrdColor)
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
                }
            }.padding(.vertical, 35)
            
            /* Pokemon stats */
            ZStack {
                infoBox(title: "Base Stats", height: 225, offset: -115, color: pokemonBgrdColor)
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
            }
        }
        .padding(.horizontal, 40)
    }
}


/* To be able to view pokemon */
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
        PokemonDetailView(pokemonEntry: mockPokemonDetails, pokemonSprite: Image("Pikachu"))
    }
}
