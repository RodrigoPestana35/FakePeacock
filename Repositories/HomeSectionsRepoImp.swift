import Foundation

class HomeSectionsRepoImp : HomeSectionsRepo {
    func  execute() async throws -> HomeSectionsDto {
        guard
            let url = URL(string: Self.Constants.homeSectionsUrl)
        else
        {
            throw HomeSectionsRepoError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("US", forHTTPHeaderField: "x-skyott-activeterritor")
        request.setValue("MOBILE", forHTTPHeaderField: "x-skyott-device")
        request.setValue("en", forHTTPHeaderField: "x-skyott-language")
        request.setValue("ANDROID", forHTTPHeaderField: "x-skyott-platform")
        request.setValue("NBCUOTT", forHTTPHeaderField: "x-skyott-proposition")
        request.setValue("NBCU", forHTTPHeaderField: "x-skyott-provider")
        request.setValue("US", forHTTPHeaderField: "x-skyott-territory")
        
        do{
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let homeSections = try? JSONDecoder().decode(HomeSectionsDto.self, from: data) {
                return homeSections
            }
            else {
                print("Decoding Error")
                throw HomeSectionsRepoError.encodingError
                
            }
        }
        catch {
            print("Failed to Send POST Request \(error)")
            throw HomeSectionsRepoError.invalidResponse
        }
    }
    
    
}

extension HomeSectionsRepoImp{
    enum Constants{
        static let homeSectionsUrl = "https://mobile.clients.peacocktv.com/bff/sections/v1?template=sections_v2&segment=all_free_users&node_id=32849634-d3d3-11e9-bbc6-d7a405d0af9d"
    }
}

enum HomeSectionsRepoError: Error {
    case invalidURL
    case encodingError
    case invalidResponse
}
