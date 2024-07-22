import Foundation

class SearchPokemonUseCaseImpl: SearchPokemonsUseCase {
    func execute() async -> PokemonDto? {
        guard
            let url = URL(string: Self.Constants.dittoUrl)
        else {
            return nil
        }
        
        let request = URLRequest(url: url)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let pokemon = try? JSONDecoder().decode(PokemonDto.self, from: data) {
                return pokemon
            }
            else {
                print("Invalid Response")
                return nil
            }
        }
        catch {
            print("Failed to Send POST Request \(error)")
            return nil
        }
    }
    
    
    
    func execute(handleSuccess: @escaping (PokemonDto) -> Void) {
        guard
            let url = URL(string: Self.Constants.dittoUrl)
        else {
            return
        }
        
        let request = URLRequest(url: url)
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                
                if let pokemon = try? JSONDecoder().decode(PokemonDto.self, from: data) {
                    handleSuccess(pokemon)
                }
                else {
                    print("Invalid Response")
                }
            }
            catch {
                print("Failed to Send POST Request \(error)")
            }
        }
    }
}


extension SearchPokemonUseCaseImpl {
    enum Constants {
        static let dittoUrl = "https://pokeapi.co/api/v2/pokemon/ditto"
    }
}
