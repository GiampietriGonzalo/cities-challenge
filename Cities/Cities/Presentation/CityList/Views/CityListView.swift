//
//  CityListView.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

import SwiftUI

struct CityListView<Coordinator: CityListViewCoordinatorViewModelProtocol>: View {
    
    let viewModel: CityListViewModelProtocol
    let coordinator: Coordinator
    
    var body: some View {
        switch viewModel.viewData.state {
        case .loading:
            Text("Loading...")
                .task {
                    await viewModel.load()
                }
        case .loaded(let cities):
            buildCityList(cities: cities)
        case .onError(let error):
            Text("Error: \(error)")
        }
    }
    
    @ViewBuilder
    func buildCityList(cities: [CityLocationViewData]) -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(cities) { city in
                    CityCellView(city: city)
                    Divider()
                }
            }
        }
    }
}

#Preview {
    CityListView(viewModel: AppContainer.shared.buildCityListViewModel(),
                 coordinator: AppContainer.shared.coordinator)
}
