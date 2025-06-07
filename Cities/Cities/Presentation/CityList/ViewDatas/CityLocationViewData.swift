//
//  CityLocationViewData.swift
//  Cities
//
//  Created by Gonza Giampietri on 04/06/2025.
//
import Foundation

struct CityLocationViewData: Identifiable, Equatable {
    let id: UUID = UUID()
    let title: String
    let subtitle: String
    let detailButtonText: String
    let onSelect: (Bool) -> Void
    
    static func == (lhs: CityLocationViewData, rhs: CityLocationViewData) -> Bool {
        lhs.id == rhs.id
    }
}
