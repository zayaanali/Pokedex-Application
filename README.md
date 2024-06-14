<h1 align="center">Pokedex Application</h1>

<p align="center">
  This repository contains project files for a simple application that pulls a list of all pokemon from PokeAPI and provides the ability to view more detailed information about each Pokemon
<p align="center">
<img src="/IMG/home.png" width="320"/>
<img src="/IMG/detail.png" width="320"/>
</p>
  
## Libraries
Charts: Used for data presentation. No other libraries used

## Getting Started
To run the app, just clone the repository and open Pokedex.xcodeproj

## Description of Testing
The following are the tests that were simulated and confirmed to be working
1) Open Application. Search for "Empoleon". Confirm 1 result (Empoleon)
2) Search Pikachu. Open detail view. Stats and image match those of official Pokemon site
3) 20 Items present on each page. Next page loads next 20 items in Pokedex. Previous page returns to first 20 items of the Pokedex.
4) Observe list. All pokemon present on list are cached. Go to next page. Observe all pokemon on list are added to cache. 

## TBD
Coming soon!
