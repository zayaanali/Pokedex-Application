import XCTest
@testable import Pokedex // Replace with your actual app module name

class PokedexListTests: XCTestCase {
    var pokedexList: PokedexList!
    let testData: [PokemonEntry] = [
        PokemonEntry(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),
        // Add more test data as needed
    ]

    override func setUpWithError() throws {
        // Initialize PokedexList
        pokedexList = PokedexList()
        pokedexList.pokeDex = testData // Set test data directly
    }

    func testNonFilteredPokemonList() {
        // Simulate UI appearing (if necessary in your implementation)
        pokedexList.onAppear()
        
        // Validate non-filtered list
        let list = pokedexList.pokeDex
        
        print(pokedexList.pokeDex)
        
        // Assert that the number of items in the non-filtered list matches the test data count
        XCTAssertEqual(list.count, testData.count)
    }
}
