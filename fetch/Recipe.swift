//
//  Recipe.swift
//  fetch
//
//  Created by Travis Kessinger on 1/30/25.
//

import Foundation

struct Recipes: Codable {
    let recipes: [Recipe]
}

struct Recipe: Codable, Identifiable {
    let cuisine: String
    let name: String
    let largePhotoURL: String?
    let smallPhotoURL: String?
    let sourceURL: String?
    let uuid: String
    let youtubeURL: String?
    
    var id: String {
        return uuid
    }
    
    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case largePhotoURL = "photo_url_large"
        case smallPhotoURL = "photo_url_small"
        case sourceURL = "source_url"
        case uuid
        case youtubeURL = "youtube_url"
    }
}
