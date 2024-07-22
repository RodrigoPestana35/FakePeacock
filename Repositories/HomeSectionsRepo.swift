import Foundation

protocol HomeSectionsRepo{
    func execute() async throws -> HomeSectionsDto
//    func execute() -> HomeSectionsDto
}
