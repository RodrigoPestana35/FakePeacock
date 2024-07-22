import Foundation

protocol SearchPokemonsUseCase {
    func execute() async -> PokemonDto?
    func execute(handleSuccess: @escaping (PokemonDto) -> Void)
}
