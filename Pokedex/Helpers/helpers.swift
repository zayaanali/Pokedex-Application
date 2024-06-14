//
//  helpers.swift
//  Pokedex-testapp
//
//  Created by Zayaan Ali on 6/12/24.
//

import Foundation
import SwiftUI

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

enum FetchError: Error {
    case invalidImageData
}

func infoBox (title: String, height: CGFloat, offset: CGFloat, color: Color) -> some View {
    ZStack {
        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: .continuous)
            .frame(height: height)
            .foregroundColor(Color.white)
            .shadow(radius: 1)
            .padding(.horizontal, 5)
        
        Capsule() // Text Header
            .stroke(color, lineWidth: 2)
            .background(.white)
            .frame(width: 140, height: 30)
            .overlay(
                Text(title)
                    .foregroundColor(color)
                    .font(.system(size: 13))
                    .bold()
            )
            .offset(x: 0, y: offset)
    }
}
