//
//  FavoriteCity.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

import Foundation
import SwiftData

@Model
final class FavoriteCity {
    @Attribute(.unique) private var id: Int
    var isFavorite: Bool = false
    
    init(id: Int) {
        self.id = id
    }
    
    func getId() -> Int { id }
}
