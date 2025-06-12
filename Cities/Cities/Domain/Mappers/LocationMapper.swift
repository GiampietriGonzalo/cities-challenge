//
//  LocationMapper.swift
//  Cities
//
//  Created by Gonza Giampietri on 12/06/2025.
//

import SwiftUI
import MapKit

struct LocationMapper: LocationMapperProtocol {
    func map(_ location: CityLocation) -> MapCameraPosition {
        MapCameraPosition.region(.init(center: .init(latitude: location.coordinate.latitude,
                                                     longitude: location.coordinate.longitude),
                                       latitudinalMeters: 50000, longitudinalMeters: 50000))
    }
}
