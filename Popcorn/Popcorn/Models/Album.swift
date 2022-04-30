//
//  Album.swift
//  Popcorn
//
//  Created by Enes Buğra Yenidünya on 29.04.2022.
//

import Foundation

struct Album: Codable, Hashable {
    let uuid: UUID?
    let id: Int?
    let userId: Int?
    let title: String?
}
