//
//  LocationMapperProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 12/06/2025.
//

import SwiftUI
import MapKit

protocol LocationMapperProtocol {
    func map(_ location: CityLocation) -> MapCameraPosition
}
