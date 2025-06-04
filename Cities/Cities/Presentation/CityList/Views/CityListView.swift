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
    @State private var deviceOrientation = UIDeviceOrientation.unknown
    
    var body: some View {
        Group {
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
        .onRotate { newOrientation in
            deviceOrientation = newOrientation
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
