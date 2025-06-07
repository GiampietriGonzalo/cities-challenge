//
//  MapLocationToCameraPositionUseCase.swift
//  Cities
//
//  Created by Gonza Giampietri on 06/06/2025.
//

import SwiftUI
import MapKit

final class MapLocationToCameraPositionUseCase: MapLocationToCameraPositionUseCaseProtocol {
    func execute(_ location: CityLocation) -> MapCameraPosition {
        MapCameraPosition.region(.init(center: .init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
                                       latitudinalMeters: 50000, longitudinalMeters: 50000))
    }
}
