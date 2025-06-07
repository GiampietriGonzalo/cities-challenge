//
//  CitiesApp.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

import SwiftUI
import SwiftData

@main
struct CitiesApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([FavoriteCity.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            CityListCoordinatorView(viewModel: AppContainer.shared.coordinator)
                .task {
                    setupModelContext()
                }
        }
        .modelContainer(sharedModelContainer)
    }
    
    func setupModelContext() {
        let context = ModelContext(sharedModelContainer)
        AppContainer.shared.modelContext = context
    }
}
