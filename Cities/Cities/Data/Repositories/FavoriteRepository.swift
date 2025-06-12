//
//  FavoriteRepository.swift
//  Cities
//
//  Created by Gonza Giampietri on 07/06/2025.
//

import SwiftData
import Foundation

final class FavoriteRepository: FavoriteRepositoryProtocol {
    private let modelContext: ModelContext?
    
    init(modelContext: ModelContext?) {
        self.modelContext = modelContext
    }
    
    func insertFavorite(cityId: Int) throws(CustomError) {
        guard let modelContext else {
            throw CustomError.serviceError("Context not available")
        }
        
        let predicate = #Predicate<FavoriteCity> { $0.id == cityId }
        let request = FetchDescriptor<FavoriteCity>(predicate: predicate)
       
        do {
            let exists = try !modelContext.fetch(request).isEmpty
            if !exists { modelContext.insert(FavoriteCity(id: cityId, isFavorite: true)) }
        } catch {
            throw CustomError.serviceError("Error: favorite city not found")
        }
        
        try save()
    }
    
    func isFavorite(cityId: Int) throws(CustomError) -> Bool {
        guard let modelContext else {
            throw CustomError.serviceError("Context not available")
        }
        let predicate = #Predicate<FavoriteCity> { $0.id == cityId }
        let request = FetchDescriptor<FavoriteCity>(predicate: predicate)
        
        do {
            return try modelContext.fetchCount(request) > 0
        } catch {
            throw CustomError.serviceError("Error fetching favorites")
        }
    }
    
    private func save() throws(CustomError) {
        guard let modelContext else {
            throw CustomError.serviceError("Context not available")
        }
        
        do {
            try modelContext.save()
        } catch {
            throw CustomError.serviceError("Error saving favorites")
        }
    }
    
    deinit {
        try? save()
    }
}
