import Foundation

struct HomeSectionsRailsDto: Decodable{
    let type: String
    var items: [HomeSectionsItemsDto]?
    let title: String
    let renderHint: RailRenderHintDto?
}
