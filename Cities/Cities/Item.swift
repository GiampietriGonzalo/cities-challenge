//
//  Item.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
