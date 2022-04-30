//
//  Section.swift
//  Popcorn
//
//  Created by Enes Buğra Yenidünya on 30.04.2022.
//

import Foundation

final class Section: Hashable {
    
    // MARK: Properties
    var id = UUID()
    var title: String
    var photos: [HomeCollectionViewCellViewModel]
    
    // MARK: Init
    init(title: String, photos: [HomeCollectionViewCellViewModel]) {
        self.title = title
        self.photos = photos
    }
    
    // MARK: Functions
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Section, rhs: Section) -> Bool {
        lhs.id == rhs.id
    }
}
