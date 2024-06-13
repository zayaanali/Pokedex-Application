//
//  helpers.swift
//  Pokedex-testapp
//
//  Created by Zayaan Ali on 6/12/24.
//

import Foundation

func convertHeight(decameters: Int) -> (feet: Int, inches : Int) {
    let totalInches = Double(decameters) * 10 / 2.54
    let feet = Int(totalInches / 12)
    let inches = Int(totalInches.truncatingRemainder(dividingBy: 12).rounded())
    return (feet, inches)
}

func convertWeight(decagrams: Int) -> Int {
    return Int(( Double(decagrams) / 4.5359 ).rounded())
}

func shortenedStatName (statName: String) -> String {
    switch statName {
    case "hp":
        return "HP"
    case "attack":
        return "Atk"
    case "defense":
        return "Def"
    case "special-attack":
        return "Sp. Atk"
    case "special-defense":
        return "Sp. Def"
    case "speed":
        return "Spd"
    default:
        return statName
    }
}
