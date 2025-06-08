//
//  FavoriteCity.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

import Foundation
import SwiftData

@Model
final class FavoriteCity: Equatable {
    @Attribute(.unique)  var id: Int
    var isFavorite: Bool = false
    
    init(id: Int, isFavorite: Bool = false) {
        self.id = id
        self.isFavorite = isFavorite
    }
}
