//
//  MapViewModel.swift
//  Cities
//
//  Created by Gonza Giampietri on 04/06/2025.
//

import Observation
import SwiftUI
import MapKit

@Observable
final class MapViewModel: MapViewModelProtocol {
    var viewData: MapViewData
    
    init(viewData: MapViewData) {
        self.viewData = viewData
    }
}
    
