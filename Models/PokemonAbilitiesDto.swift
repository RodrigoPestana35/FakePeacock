import Foundation

struct PokemonDto: Decodable{
    let abilities: [PokemonAbilityDto]
}

struct PokemonAbilityDto: Decodable {
    let ability: PokemonActualAbilityDto
    let slot: Int
}

struct PokemonActualAbilityDto: Decodable {
    let name: String
    let url: String
}
