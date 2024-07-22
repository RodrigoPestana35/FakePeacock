import Foundation

protocol MainViewModel {
    func searchPokemon() async -> PokemonDto?
    func searchPokemon(handleSuccess: @escaping (PokemonDto) -> Void)
}

class MainViewModelImpl: MainViewModel{
    private let searchPokemonUseCase: SearchPokemonsUseCase = SearchPokemonUseCaseImpl()
    
    func searchPokemon() async -> PokemonDto? {
        return await searchPokemonUseCase.execute()
    }
    
    func searchPokemon(handleSuccess: @escaping (PokemonDto) -> Void) {
        return searchPokemonUseCase.execute(handleSuccess: handleSuccess)
    }

}
