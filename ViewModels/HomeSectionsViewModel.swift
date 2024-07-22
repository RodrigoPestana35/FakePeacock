import Foundation

protocol HomeSectionsViewModel{
    func execute () async throws -> [HomeSectionsRailsDto]
}
