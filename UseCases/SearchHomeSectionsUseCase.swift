import Foundation

protocol SearchHomeSectionsUseCase{
    func execute () async throws -> HomeSectionsDto
}
