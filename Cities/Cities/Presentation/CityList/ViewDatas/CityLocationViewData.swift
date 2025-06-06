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
}
