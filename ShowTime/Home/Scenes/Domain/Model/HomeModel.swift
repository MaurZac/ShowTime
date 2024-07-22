//
//  HomeModel.swift
//  ShowTime
//
//  Created by MaurZac on 21/07/24.
//

struct MovieResponse: Codable {
    let page: Int
    let results: [Movie]
}

struct Movie: Codable, Identifiable {
    let adult: Bool
    let backdropPath: String?
    let id: Int
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let title: String
 
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
      
    }
    
        init(entity: MovieEntity) {
            self.title = entity.title ?? ""
            self.posterPath = entity.imageUrl
            self.overview = entity.overview ?? ""
            self.releaseDate = entity.releaseDate ?? ""
            self.popularity = entity.popularity
            self.id = Int(entity.id)
            self.backdropPath = entity.backdropPath
            self.adult = entity.adult
        }
}
