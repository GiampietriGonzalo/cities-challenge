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
    var body: some Scene {
        WindowGroup {
            CityListCoordinatorView(viewModel: AppContainer.shared.coordinator)
        }
        .modelContainer(AppContainer.shared.modelContainer)
    }
}
