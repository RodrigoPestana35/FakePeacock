import Foundation

class SearchHomeSectionsUseCaseImp: SearchHomeSectionsUseCase{
    
    private let homeSectionsRepo: HomeSectionsRepo = HomeSectionsRepoImp()
    
    func execute() async throws -> HomeSectionsDto {
        return try await homeSectionsRepo.execute()
    }
    
    
}
