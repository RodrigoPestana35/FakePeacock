import Foundation

class HomeSectionsViewModelImp: HomeSectionsViewModel{
    
    private let searchHomeSectionsUseCase: SearchHomeSectionsUseCase = SearchHomeSectionsUseCaseImp()
    
    
//    func execute() -> HomeSectionsDto {
//        return searchHomeSectionsUseCase.execute()
//    }
    
    func execute() async throws -> [HomeSectionsRailsDto] {
        let data = try await searchHomeSectionsUseCase.execute()
        
        return data.data.group.rails.filter({ $0.items != nil && (($0.items?.count) != 0) })
    }
    
    
}
