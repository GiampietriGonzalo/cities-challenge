//
//  FavoriteRepository.swift
//  Cities
//
//  Created by Gonza Giampietri on 07/06/2025.
//

import SwiftData
import Foundation

final class FavoriteRepository {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func toggleFavorite(cityId: Int) throws(CustomError) {
        let predicate = #Predicate<FavoriteCity> { $0.id == cityId }
        let request = FetchDescriptor<FavoriteCity>(predicate: predicate)
        
        do {
            let existing = try modelContext.fetch(request).first
            
            if let existing = existing {
                modelContext.delete(existing)
            } else {
                modelContext.insert(FavoriteCity(id: cityId))
            }
        } catch {
            throw CustomError.serviceError("Error fetching favorites")
        }
        
        do {
            try modelContext.save()
        } catch {
            throw CustomError.serviceError("Error saving favorites")
        }
    }
    
    func isFavorite(cityId: Int) throws(CustomError) -> Bool {
        let predicate = #Predicate<FavoriteCity> { $0.id == cityId }
        let request = FetchDescriptor<FavoriteCity>(predicate: predicate)
        
        do {
            return try modelContext.fetchCount(request) > 0
        } catch {
            throw CustomError.serviceError("Error fetching favorites")
        }
    }
}
