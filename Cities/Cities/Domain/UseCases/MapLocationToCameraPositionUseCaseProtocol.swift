//
//  MapLocationToCameraPositionUseCaseProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 06/06/2025.
//

import SwiftUI
import MapKit

protocol MapLocationToCameraPositionUseCaseProtocol {
    func execute(_ location: CityLocation) -> MapCameraPosition
}
