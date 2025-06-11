//
//  MapLocationToCameraPositionUseCaseProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 06/06/2025.
//

import SwiftUI
import MapKit

protocol MapLocationToCameraPositionUseCaseProtocol {
    
    /**
     *  Mao a given CityLocation model to a MapCameraPosition
     * - Parameters:
     *      - location: A CityLocation model to map
     * - Returns: a MapCameraPosition model
     */
    func execute(_ location: CityLocation) -> MapCameraPosition
}
