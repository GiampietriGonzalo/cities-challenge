//
//  AppPushNavigationType.swift
//  Cities
//
//  Created by Gonza Giampietri on 04/06/2025.
//

import Foundation

enum AppPushNavigationType: PushNavigationType {
    var id: UUID { UUID() }
   
    case list
    case detail(cityName: String, countryCode: String)
    case map(viewData: MapViewData)
}

extension AppPushNavigationType: Hashable {
    static func == (lhs: AppPushNavigationType, rhs: AppPushNavigationType) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
