//
//  Photo.swift
//  Popcorn
//
//  Created by Enes Buğra Yenidünya on 29.04.2022.
//

import Foundation

struct Photo: Codable, Identifiable, Hashable {

    private enum CodingKeys : String, CodingKey { case id, albumId, title, url, thumbnailUrl }
    
    let id: Int?
    let albumId: Int?
    let title: String?
    let url: String?
    let thumbnailUrl: String?
}
