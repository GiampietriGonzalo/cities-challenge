//
//  CityListViewCoordinatorViewModel.swift
//  Cities
//
//  Created by Gonza Giampietri on 04/06/2025.
//

import SwiftUI
import Observation

@Observable
final class CityListViewCoordinatorViewModel: CityListViewCoordinatorViewModelProtocol{
    var navigationPath = NavigationPath()
    
    //MARK: Binding
    var navigationPathBinding: Binding<NavigationPath> {
        Binding(get: { self.navigationPath },
                set: { self.navigationPath = $0 })
    }
    
    //MARK: Navigation methods
    func push(_ item: NavigationType) {
        self.navigationPath.append(item)
    }
    
    func pop() {
        guard !navigationPath.isEmpty else { return }
        self.navigationPath.removeLast()
    }
    
    func popToRoot() {
        guard !navigationPath.isEmpty else { return }
        self.navigationPath.removeLast(navigationPath.count)
    }
    
    //MARK: Building methods
    @ViewBuilder func build(for item: NavigationType) -> some View {
        switch item {
        case .list:
            CityListView(viewModel: AppContainer.shared.buildCityListViewModel(),
                         coordinator: AppContainer.shared.coordinator)
        case let .map(cities: cities):
            EmptyView()
        case let .detail(city: city):
            EmptyView()
        }
    }
}
