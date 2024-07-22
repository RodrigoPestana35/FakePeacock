import Foundation

struct HomeSectionsItemsDto: Decodable {
    let type: String
    let seasonCount: Int?
    let episodeCount: Int?
    let title: String
    let classification: String?
    let images: [ItemsImagesDto]
    let genreList: [ItemGenreListDto]?
    let year: Int?
    let description: String?
}
