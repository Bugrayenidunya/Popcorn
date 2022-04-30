//
//  Address.swift
//  Popcorn
//
//  Created by Enes Buğra Yenidünya on 29.04.2022.
//

import Foundation

// MARK: - Address
struct Address: Codable, Hashable {
    let street: String?
    let suite: String?
    let city: String?
    let zipcode: String?
    let geo: Location?
}

// MARK: - Location
struct Location: Codable, Hashable {
    let lat: String?
    let lng: String?
}
