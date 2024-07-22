import Foundation

struct HomeSectionsGroupDto: Decodable {
    let type: String
    let rails: [HomeSectionsRailsDto]
}
